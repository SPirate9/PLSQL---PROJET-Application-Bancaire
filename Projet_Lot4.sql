--========================================
--////// Compléments : Vues  \\\\\\
--========================================

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
