REM   Script: Session 01
REM   FIN

DROP TABLE BANQUE CASCADE CONSTRAINT;

DROP TABLE OPERATION CASCADE CONSTRAINT;

DROP TABLE COMPTE CASCADE CONSTRAINT;

DROP TABLE TYPECOMPTE CASCADE CONSTRAINT;

DROP TABLE AUDITDECOUVERT CASCADE CONSTRAINT;

CREATE TABLE BANQUE 
( 
    IdBanque INTEGER, 
    LibelleBanque VARCHAR(50) NOT NULL, 
    CPBanque CHAR(5) NOT NULL, 
    AdresseBanque VARCHAR(50) NOT NULL, 
    VilleBanque VARCHAR(30) NOT NULL 
);

DROP SEQUENCE SeqIdBanque;

CREATE SEQUENCE SeqIdBanque START WITH 10000 INCREMENT BY 10;

ALTER TABLE BANQUE ADD CONSTRAINT PK_IdBanque PRIMARY KEY(IdBanque);

ALTER TABLE BANQUE ADD CONSTRAINT U_LibelleBanque UNIQUE(LibelleBanque);

CREATE TABLE AUDITDECOUVERT 
( 
    IdAudit INTEGER, 
    IdCompte INTEGER NOT NULL, 
    LibelleCompte VARCHAR(30) NOT NULL, 
    SoldeCompte NUMBER(10,2) NOT NULL, 
    DecouvertAutorise NUMBER(10,2) NOT NULL, 
    Depassement NUMBER(10,2) NOT NULL, 
    IdDerniereOperation INTEGER NOT NULL 
);

DROP SEQUENCE SeqAudit;

CREATE SEQUENCE SeqIdAudit;

CREATE TABLE TYPECOMPTE 
( 
    IdTypeCompte INTEGER, 
    LibelleTypeCompte VARCHAR(30) NOT NULL 
);

DROP SEQUENCE SeqIdTypeCompte;

CREATE SEQUENCE SeqIdTypeCompte;

ALTER TABLE TYPECOMPTE ADD CONSTRAINT PK_IdTypeCompte PRIMARY KEY(IdTypeCompte);

CREATE TABLE OPERATION 
( 
    IdOperation INTEGER, 
    DateOperation DATE NOT NULL, 
    MontantOperation NUMBER(10,2) NOT NULL 
);

DROP SEQUENCE SeqIdOperation;

CREATE SEQUENCE SeqIdOperation;

ALTER TABLE OPERATION ADD CONSTRAINT PK_IdOperation PRIMARY KEY(IdOperation);

CREATE TABLE COMPTE 
( 
    IdCompte INTEGER, 
    LibelleCompte VARCHAR(30) NOT NULL, 
    SoldeCompte NUMBER(10,2) NOT NULL, 
    DecouvertAutorise NUMBER(10,2) NOT NULL, 
    DateOuvertureCompte DATE NOT NULL 
);

DROP SEQUENCE SeqIdCompte;

CREATE SEQUENCE SeqIdCompte;

ALTER TABLE COMPTE ADD CONSTRAINT PK_IdCompte PRIMARY KEY(IdCompte);

ALTER TABLE COMPTE ADD CONSTRAINT U_LibelleCompte UNIQUE(LibelleCompte);

ALTER TABLE COMPTE ADD (IdBanque INTEGER);

ALTER TABLE COMPTE MODIFY (IdBanque INTEGER CONSTRAINT FK_IdBanque REFERENCES BANQUE(IdBanque));

ALTER TABLE COMPTE MODIFY (IdBanque NOT NULL);

ALTER TABLE COMPTE ADD (IdTypeCompte INTEGER);

ALTER TABLE COMPTE MODIFY (IdTypeCompte INTEGER CONSTRAINT FK_IdTypeCompte REFERENCES TYPECOMPTE(IdTypeCompte));

ALTER TABLE COMPTE MODIFY (IdTypeCompte NOT NULL);

ALTER TABLE OPERATION ADD (IdCompte INTEGER);

ALTER TABLE OPERATION MODIFY (IdCompte INTEGER CONSTRAINT FK_IdCompte REFERENCES COMPTE(IdCompte));

ALTER TABLE OPERATION MODIFY (IdCompte NOT NULL);

INSERT INTO BANQUE (IdBanque, LibelleBanque, CPBanque, AdresseBanque, VilleBanque) VALUES  
(10000, 'Banque Nationale', '75001', '1 Avenue des Champs-Élysées', 'Paris');

INSERT INTO BANQUE (IdBanque, LibelleBanque, CPBanque, AdresseBanque, VilleBanque) VALUES  
(10010, 'Banque Populaire', '69001', '15 Rue de la République', 'Lyon');

INSERT INTO BANQUE (IdBanque, LibelleBanque, CPBanque, AdresseBanque, VilleBanque) VALUES  
(10020, 'Crédit Agricole', '13001', '12 Rue Breteuil', 'Marseille');

INSERT INTO AUDITDECOUVERT (IdAudit, IdCompte, LibelleCompte, SoldeCompte, DecouvertAutorise, Depassement, IdDerniereOperation) VALUES  
(SeqIdAudit.NEXTVAL, 1, 'Compte courant', 1500, -1000, 200, 1);

INSERT INTO AUDITDECOUVERT (IdAudit, IdCompte, LibelleCompte, SoldeCompte, DecouvertAutorise, Depassement, IdDerniereOperation) VALUES  
(SeqIdAudit.NEXTVAL, 2, 'Livret A', 5000, 0, 0, 2);

INSERT INTO AUDITDECOUVERT (IdAudit, IdCompte, LibelleCompte, SoldeCompte, DecouvertAutorise, Depassement, IdDerniereOperation) VALUES  
(SeqIdAudit.NEXTVAL, 3, 'PEL', 20000, 0, 0, 3);

INSERT INTO TYPECOMPTE (IdTypeCompte, LibelleTypeCompte) VALUES  
(SeqIdTypeCompte.NEXTVAL, 'Compte courant');

INSERT INTO TYPECOMPTE (IdTypeCompte, LibelleTypeCompte) VALUES  
(SeqIdTypeCompte.NEXTVAL, 'Livret A');

INSERT INTO TYPECOMPTE (IdTypeCompte, LibelleTypeCompte) VALUES  
(SeqIdTypeCompte.NEXTVAL, 'PEL');

INSERT INTO COMPTE (IdCompte, LibelleCompte, SoldeCompte, DecouvertAutorise, DateOuvertureCompte, IdBanque, IdTypeCompte) VALUES  
(SeqIdCompte.NEXTVAL, 'Compte courant', 1500, -1000, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 10000, 1);

INSERT INTO COMPTE (IdCompte, LibelleCompte, SoldeCompte, DecouvertAutorise, DateOuvertureCompte, IdBanque, IdTypeCompte) VALUES  
(SeqIdCompte.NEXTVAL, 'Livret A', 5000, 0, TO_DATE('2022-01-15', 'YYYY-MM-DD'), 10010, 2);

INSERT INTO COMPTE (IdCompte, LibelleCompte, SoldeCompte, DecouvertAutorise, DateOuvertureCompte, IdBanque, IdTypeCompte) VALUES  
(SeqIdCompte.NEXTVAL, 'PEL', 20000, 0, TO_DATE('2022-02-01', 'YYYY-MM-DD'), 10020, 3);

INSERT INTO OPERATION (IdOperation, DateOperation, MontantOperation, IdCompte)  
VALUES (SeqIdOperation.NEXTVAL, TO_DATE('2022-03-27', 'yyyy-mm-dd'), 1000.00, 1);

INSERT INTO OPERATION (IdOperation, DateOperation, MontantOperation, IdCompte)  
VALUES (SeqIdOperation.NEXTVAL, TO_DATE('2022-03-27', 'yyyy-mm-dd'), 1000.00, 3);

 CREATE VIEW CONSULTERCOMPTE AS  
  SELECT c.IdCompte, c.LibelleCompte, t.LibelleTypeCompte, c.SoldeCompte  
  FROM COMPTE c  
  INNER JOIN TYPECOMPTE t  
  ON c.IdTypeCompte = t.IdTypeCompte 
 
-- Une autre Solution. -- 
 
--  CREATE VIEW CONSULTERCOMPTE AS -- 
--  SELECT C.IDCOMPTE AS "Identifiant du compte", -- 
--  C.LIBELLECOMPTE AS "Libelle du compte", -- 
--  T.LIBELLETYPECOMPTE AS "Libelle du type de compte", -- 
--  C.SOLDECOMPTE AS "solde du compte" -- 
--  FROM COMPTE C -- 
--  JOIN TYPECOMPTE T ON C.IDTYPECOMPTE=T.IDTYPECOMPTE; --;

CREATE VIEW CONSULTERDECOUVERT AS 
  SELECT a.IdCompte, a.LibelleCompte, t.LibelleTypeCompte, a.SoldeCompte, a.Depassement 
  FROM AUDITDECOUVERT a 
  INNER JOIN TYPECOMPTE t 
  ON a.IdCompte = t.IdTypeCompte;

CREATE VIEW CONSULTEROPERATION AS 
  SELECT IdOperation, MontantOperation, DateOperation 
  FROM OPERATION 
  ORDER BY DateOperation DESC;

INSERT INTO OPERATION (IdOperation, DateOperation, MontantOperation, IdCompte)  
VALUES (SeqIdOperation.NEXTVAL, TO_DATE('2022-03-27', 'yyyy-mm-dd'), 1000.00, 2);

CREATE OR REPLACE PACKAGE ACTIONSURCOMPTE 
IS 
PROCEDURE AJOUTNOUVOPERATION(Idcompte INTEGER , Value NUMBER) ;   
PROCEDURE ANNULEROPERATION(IdOpt INTEGER) ;		 
PROCEDURE MAJDECOUVERTAUTORISE (Idcpte INTEGER, Value NUMBER) ;   
PROCEDURE MAJMONTANTOPERATION (Idopt INTEGER, Value NUMBER) ;    
PROCEDURE FAIRETRANSFERTCOMPTE (CptOrig INTEGER, CptDest INTEGER, Value NUMBER) ;  
FUNCTION BANQUEOPERATION (IdOpt INTEGER ) RETURN VARCHAR ;  
FUNCTION SOLDECOMPTE (Cpt INTEGER) RETURN NUMBER ;  
END ACTIONSURCOMPTE ; 
/

CREATE OR REPLACE PACKAGE BODY ACTIONSURCOMPTE   
IS   
     
PROCEDURE AJOUTNOUVOPERATION(Idcompte INTEGER , Value NUMBER)    
IS     
BEGIN    
INSERT INTO OPERATION (IdOperation, DateOperation, MontantOperation, IdCompte)     
  VALUES (SeqIdOperation.NEXTVAL, SYSDATE, Value, Idcompte);    
END AJOUTNOUVOPERATION;    
   
PROCEDURE ANNULEROPERATION(IdOpt INTEGER)   
IS    
 BEGIN   
    INSERT INTO OPERATION (IdOperation, DateOperation, MontantOperation, IdCompte)   
      SELECT   
        SeqIdOperation.NEXTVAL,   
        SYSDATE,   
        - MontantOperation,   
        IdCompte   
      FROM OPERATION   
      WHERE IdOperation = IdOpt;   
END ANNULEROPERATION;   
  
-- Une autre Solution. --  
  
-- PROCEDURE ANNULEROPERATION(IdOpt INTEGER) --  
-- IS --  
-- v_amount NUMBER(10, 2); --  
--  v_newIdOperation INTEGER; --  
--  BEGIN --  
--  SELECT MontantOperation --  
--  INTO v_amount --  
--  FROM OPERATION --  
--  WHERE IdOperation = IdOpt; --  
--  SELECT SeqIdOperation.NEXTVAL --  
--   INTO v_newIdOperation --  
--   FROM DUAL; --  
--   INSERT INTO OPERATION (IdOperation, DateOperation, MontantOperation, IdCompte) --  
--   VALUES (v_newIdOperation, SYSDATE, -v_amount, --  
--         (SELECT IdCompte FROM OPERATION WHERE IdOperation = IdOpt)); --  
-- END ANNULEROPERATION; --  
   
PROCEDURE MAJDECOUVERTAUTORISE (Idcpte INTEGER, Value NUMBER)    
IS    
BEGIN   
UPDATE COMPTE   
 SET DecouvertAutorise = Value   
  WHERE IdCompte = Idcpte;   
END MAJDECOUVERTAUTORISE;   
   
PROCEDURE MAJMONTANTOPERATION(Idopt INTEGER , Value NUMBER)  
IS   
Idcpt INTEGER; 
BEGIN  
Select idcompte into Idcpt from operation where idoperation = Idopt; 
  BEGIN   
      ACTIONSURCOMPTE.ANNULEROPERATION(Idopt);   
  END;  
  BEGIN   
    ACTIONSURCOMPTE.AJOUTNOUVOPERATION(Idcpt,Value);   
  END;  
END MAJMONTANTOPERATION;  
   
PROCEDURE FAIRETRANSFERTCOMPTE (CptOrig INTEGER, CptDest INTEGER, Value NUMBER)   
IS    
BEGIN   
    IF Value > 0 THEN   
      UPDATE COMPTE   
      SET SoldeCompte = SoldeCompte - Value   
      WHERE IdCompte = CptOrig;   
      UPDATE COMPTE   
      SET SoldeCompte = SoldeCompte + Value   
      WHERE IdCompte = CptDest;   
      COMMIT;   
    ELSE   
      RAISE_APPLICATION_ERROR(-20001,'Veuillez saisir un montant positif.');   
    END IF;   
END FAIRETRANSFERTCOMPTE;   
   
FUNCTION BANQUEOPERATION (Idopt INTEGER ) RETURN VARCHAR   
IS    
LibelleBanque VARCHAR(50);   
BEGIN   
SELECT b.LibelleBanque   
INTO LibelleBanque   
FROM BANQUE b   
INNER JOIN COMPTE c ON b.IdBanque = c.IdBanque   
INNER JOIN OPERATION o ON c.IdCompte = o.IdCompte   
WHERE o.IdOperation = Idopt;   
RETURN LibelleBanque;   
END BANQUEOPERATION;   
   
FUNCTION SOLDECOMPTE (Cpt INTEGER) RETURN NUMBER   
IS    
solde NUMBER;   
BEGIN   
SELECT soldeCompte INTO solde     
FROM Compte   
WHERE IdCompte = Cpt;   
RETURN solde;   
END SOLDECOMPTE;   
   
END ACTIONSURCOMPTE;
/

SELECT * FROM OPERATION;

BEGIN  
    ACTIONSURCOMPTE.AJOUTNOUVOPERATION(3,2000);  
END; 
/

SELECT * FROM OPERATION ;

BEGIN  
    ACTIONSURCOMPTE.ANNULEROPERATION(2);  
END; 
/

SELECT * FROM OPERATION ;

SELECT * FROM COMPTE;

BEGIN  
    ACTIONSURCOMPTE.MAJDECOUVERTAUTORISE(2,2000);  
END; 
/

SELECT * FROM COMPTE ;

SELECT * FROM OPERATION ;

BEGIN  
    ACTIONSURCOMPTE.MAJMONTANTOPERATION(5,2560);  
END; 
/

SELECT * FROM OPERATION;

SELECT * FROM COMPTE ;

BEGIN  
    ACTIONSURCOMPTE.FAIRETRANSFERTCOMPTE(1,2,2300);  
END; 
/

SELECT * FROM COMPTE;

-- TEST MONTANT NEGATIF ERREUR --
BEGIN    
    ACTIONSURCOMPTE.FAIRETRANSFERTCOMPTE(1,2,-2300);    
END; 
/

SELECT ACTIONSURCOMPTE.BANQUEOPERATION(1) FROM DUAL;

SELECT ACTIONSURCOMPTE.SOLDECOMPTE(1) FROM DUAL;

SELECT * FROM CONSULTERCOMPTE;

SELECT * FROM CONSULTERDECOUVERT;

SELECT * FROM CONSULTEROPERATION;

Select * from OPERATION 
;

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

EXECUTE ACTIONSURCOMPTE.AJOUTNOUVOPERATION(2, -1134)


Select * from OPERATION ;

-- TEST TRIGGER Q.1 : l'annulation d’une opération calcule automatiquement le nouveau montant du solde du compte associé à l’opération. --
select * from compte where IDCOMPTE = 2;

select * from operation where IDCOMPTE = 2;

BEGIN   
    ACTIONSURCOMPTE.ANNULEROPERATION(3);   
END;  
/

select * from compte where IDCOMPTE = 2;

select * from operation where IDCOMPTE = 2;

-- TEST TRIGGER Q.1 : la modification du montant d’une opération calcule automatiquement le nouveau montant du solde du compte associé à l’opération.--
select * from compte where IDCOMPTE = 2;

select * from operation where IDCOMPTE = 2;

BEGIN   
    ACTIONSURCOMPTE.MAJMONTANTOPERATION(8,2000);   
END;  
/

select * from compte where IDCOMPTE = 2;

select * from operation where IDCOMPTE = 2;

-- TEST TRIGGER Q.2 :l’opération s’effectue mais le compte est signalé dans la table « AUDITDECOUVERT » + Q.1 ajout d’une opération de débit.--
select * from compte where IDCOMPTE = 3;

select * from operation where IDCOMPTE = 3;

select * from AUDITDECOUVERT where IDCOMPTE = 3;

BEGIN   
    ACTIONSURCOMPTE.AJOUTNOUVOPERATION(3,-22000);   
END;  
/

select * from compte where IDCOMPTE = 3;

select * from operation where IDCOMPTE = 3;

select * from AUDITDECOUVERT where IDCOMPTE = 3;

-- TEST TRIGGER Q.2 :Si le solde d’un compte revient dans la limite du découvert autorisé alors il disparait de la table « AUDITDECOUVERT » + Q.1 ajout d’une opération de crédit.--
select * from compte where IDCOMPTE = 3;

select * from operation where IDCOMPTE = 3;

select * from AUDITDECOUVERT where IDCOMPTE = 3;

BEGIN   
    ACTIONSURCOMPTE.AJOUTNOUVOPERATION(3,5000);   
END;  
/

select * from compte where IDCOMPTE = 3;

select * from operation where IDCOMPTE = 3;

select * from AUDITDECOUVERT where IDCOMPTE = 3;

-- TEST TRIGGER Q.3 : Les comptes d’épargne ne peuvent pas avoir de solde négatif.--
INSERT INTO TYPECOMPTE Values (4, 'COMPTE EPARGNE');

INSERT INTO COMPTE (IdCompte, LibelleCompte, SoldeCompte, DecouvertAutorise, DateOuvertureCompte, IdBanque, IdTypeCompte) VALUES   
(4, 'Compte epargne', 1500, 0, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 10000, 4);

select * from compte where IDCOMPTE = 4;

select * from operation where IDCOMPTE = 4;

INSERT INTO OPERATION (IdOperation, DateOperation, MontantOperation, IdCompte)   
VALUES (SeqIdOperation.NEXTVAL, TO_DATE('2022-03-27', 'yyyy-mm-dd'), -2000, 4);

select * from compte where IDCOMPTE = 4;

select * from operation where IDCOMPTE = 4;

