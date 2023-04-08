--========================================
--////// LOT 2 \\\\\\
--========================================

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