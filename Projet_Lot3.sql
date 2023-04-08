--========================================
--////// LOT 3 \\\\\\
--========================================

CREATE OR REPLACE TRIGGER T_CalculSolde  
    BEFORE INSERT OR DELETE OR UPDATE ON OPERATION  
    FOR EACH ROW  
    DECLARE  
        N_MONTANTOPERATION NUMBER(10,2);  
        I_IdCompte INTEGER ;  
        I_IdOperation INTEGER ;  
          
        S_SOLDECOMPTE NUMBER(10,2);  
        N_decouvert NUMBER(10,2);  
  
        LigneAudit INTEGER;  
        V_LibelleCompte VARCHAR(30);  
  
		N_TypeCompte INTEGER;  
          
    BEGIN  
        N_MontantOperation := :NEW.MontantOperation;  
        I_IdCompte := :NEW.IdCompte;  
        I_IdOperation := :NEW.IdOperation;  
        S_soldeCompte := ACTIONSURCOMPTE.SOLDECOMPTE(I_IdCompte) ;  
        SELECT DecouvertAutorise INTO N_decouvert FROM COMPTE WHERE IdCompte = I_IdCompte ;  
		SELECT IDTYPECOMPTE INTO N_TypeCompte FROM COMPTE WHERE IDCOMPTE = I_IdCompte ;  
		SELECT COUNT(*) INTO LigneAudit FROM AUDITDECOUVERT WHERE IdCompte = I_IdCompte ;  
  
        DBMS_OUTPUT.PUT_LINE('IdCompte = '|| I_IdCompte ||' Solde = '|| S_soldeCompte ||' N_TypeCompte = '|| N_TypeCompte );  
		DBMS_OUTPUT.PUT_LINE('IdOperation = '|| I_IdOperation ||' N_MontantOperation = '|| N_MontantOperation );  
		DBMS_OUTPUT.PUT_LINE('new solde = '|| (S_soldeCompte + N_MontantOperation) || ' LigneAudit = '|| LigneAudit );  
  
		IF ( N_TypeCompte= 4) and (S_soldeCompte + N_MontantOperation  < 0) THEN  
            DBMS_OUTPUT.PUT_LINE('compte epargne');  
			RAISE_APPLICATION_ERROR(-3001,'Solde négatif pour epargne');  
          
		ELSE   
            DBMS_OUTPUT.PUT_LINE('compte pas epargne');  
			UPDATE COMPTE SET SoldeCompte=(S_soldeCompte + N_MontantOperation) WHERE IdCompte = I_IdCompte ;  
			IF (S_soldeCompte + N_MontantOperation  < N_decouvert) THEN  
				IF (LigneAudit =0 ) THEN  
                    DBMS_OUTPUT.PUT_LINE('INSERT AUDIT');  
    				SELECT LibelleCompte INTO V_LibelleCompte FROM COMPTE WHERE IdCompte = I_IdCompte ;  
    				INSERT INTO AUDITDECOUVERT (IdAudit, IdCompte, LibelleCompte, SoldeCompte, DecouvertAutorise, Depassement, IdDerniereOperation)  
                        VALUES (SeqIdAudit.NextVal, I_IdCompte, V_LibelleCompte, S_soldeCompte + N_MontantOperation, N_decouvert, ABS(S_soldeCompte + N_MontantOperation + N_decouvert), I_IdOperation) ;  
				ELSE   
            		DBMS_OUTPUT.PUT_LINE('UPDATE AUDIT');  
    				UPDATE AUDITDECOUVERT SET  
                        SoldeCompte = S_soldeCompte + N_MontantOperation,   
                        Depassement = ABS(S_soldeCompte + N_MontantOperation + N_decouvert),  
                        IdDerniereOperation = I_IdOperation  
                    WHERE IdCompte = I_IdCompte ;  
        		END IF ;  
			ELSE  
        IF (LigneAudit =0 ) THEN  
          DBMS_OUTPUT.PUT_LINE('RIEN AUDIT');  
				ELSE   
          DBMS_OUTPUT.PUT_LINE('DELETE ');  
					DELETE FROM AUDITDECOUVERT WHERE IdCompte=I_IdCompte;  
        		END IF ;  
        	END IF ;  
        END IF ;  
  
          
          
END T_CalculSolde ;  
/