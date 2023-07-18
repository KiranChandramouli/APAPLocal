*-----------------------------------------------------------------------------
* <Rating>-35</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Subrutina: L.APAP.CIERRE.ACC.AHORRO
*  Creación: 05/10/2020
*     Autor: Félix Trinidad
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.CIERRE.ACC.AHORRO(Y.ACCOUNT.ID)
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.ACCOUNT.CLOSURE
    $INSERT BP I_F.ST.CONTROL.CUENTA.AHORRO
    $INSERT LAPAP.BP L.APAP.CIERRE.ACC.AHORRO.COMO
      
    GOSUB PROCCESS

    RETURN

PROCCESS:
*********
  
    R.ACCOUNT = ""; ERR=""         
    CALL F.READ(FN.ACCOUNT, Y.ACCOUNT.ID , R.ACCOUNT, F.ACCOUNT, ERR)

    IF R.ACCOUNT THEN
        *Tomo Valores de Variables de Trabajo
        Y.VAR.CATEGORIA = R.ACCOUNT<AC.CATEGORY>
        Y.VAR.FECHA.APERTURA = R.ACCOUNT<AC.OPENING.DATE>
        
        LOCATE Y.VAR.CATEGORIA IN Y.VAR.CATEG.EXC SETTING CATEGORY.POS  THEN
        END ELSE
            GOSUB VAL.PARAM.CATEG
        END 
    END 

RETURN

VAL.PARAM.CATEG:
********************
     R.CONTROL.CUENTA.AHORRO = ""; ERR.2 =""

    CALL F.READ(FN.CONTROL.CUENTA.AHORRO, Y.VAR.CATEGORIA, R.CONTROL.CUENTA.AHORRO, F.CONTROL.CUENTA.AHORRO, ERR.2)

    IF R.CONTROL.CUENTA.AHORRO THEN
       DAYS = 'W'
       
       CALL CDD("",Y.VAR.DATE,Y.VAR.FECHA.APERTURA,DAYS)
       
       Y.VAR.DIFF.DAY  = ABS(DAYS)

       *Verifico Si Tiene Dias Para Cierre de Cuentas
       Y.DIAS.CIERRE.AUTOM = R.CONTROL.CUENTA.AHORRO<ST.L.APAP.DIAS.CIERRE.AUTOM>
       IF Y.DIAS.CIERRE.AUTOM NE "" THEN
          
          *Valido si la cantidad de dias cumple para cerrar la cuenta
          IF Y.VAR.DIFF.DAY GE Y.DIAS.CIERRE.AUTOM THEN
            GOSUB CREATE.OFS
            CALL OCOMO ("CUENTA PROCESADA=" : Y.ACCOUNT.ID)
          END 
       END 
    END
RETURN

CREATE.OFS:
***********
    SEL.ID = Y.ACCOUNT.ID

    R.ACCOUNT.CLOSURE<AC.ACL.POSTING.RESTRICT> = '90'
    R.ACCOUNT.CLOSURE<AC.ACL.CLOSE.MODE> = 'AUTO'
    R.ACCOUNT.CLOSURE<AC.ACL.CLOSE.ONLINE> = 'Y'

    APPLICATION.NAME = 'ACCOUNT.CLOSURE'
    OFS.FUNCTION1 = 'I'
    PROCESS1 = 'PROCESS'
    OFS.VERSION1 = ''
    GTSMODE1 = ''
    NO.OF.AUTH1 = '0'
    OFS.RECORD1 = ''
    VERSION1 = 'ACCOUNT.CLOSURE,CLOSE'
    MSG.ID1 = ''
    OPTION1 = ''
    AZ.OFS.SOURCE = 'DM.OFS.SRC.VAL'

    CALL OFS.BUILD.RECORD(APPLICATION.NAME,OFS.FUNCTION1,PROCESS1,VERSION1,GTSMODE1,NO.OF.AUTH1,SEL.ID,R.ACCOUNT.CLOSURE,OFS.ACC)
    MSG.ID = ''; ERR.OFS = ''
        
    CALL OFS.POST.MESSAGE(OFS.ACC,MSG.ID,AZ.OFS.SOURCE,ERR.OFS)

   * Esta linea se usa para debugear, para poder disparar los ofs
   * CALL JOURNAL.UPDATE('')
  
RETURN

END
