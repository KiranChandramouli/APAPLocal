*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.PWD
**
* Subroutine Type : VERSION
* Attached to     : REDO.CONFIRM.PASSWORD,AI.REDO.NUEVO
* Attached as     : INPUT.RTN
* Primary Purpose : Change a password inputted by user.
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 16/08/10 - First Version.
*            Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP).
*            Edgar Resendes - TAM Latin America.
*            eresendes@temenos.com
* 26/10/11 - Update to TAM coding standards and fix for PACS00146412.
*            Roberto Mondragon - TAM Latin America.
*            rmondragon@temenos.com
* 26/03/13 - Update.
*            Roberto Mondragon - TAM Latin America.
*            rmondragon@temenos.com
*-----------------------------------------------------------------------------

  INCLUDE JBC.h
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.SPF

$INSERT I_F.REDO.CONFIRM.PASSWORD

  GOSUB INITIALIZE

  RETURN

***********
INITIALIZE:
***********

  EQU TRUE TO 1, FALSE TO 0
  STR.LENGTH.PWD = ""

  FN.SPF = 'F.SPF'
  F.SPF = ''
  CALL OPF(FN.SPF,F.SPF)

  SRC.PWD = R.NEW(LOC.CP.NEW.PASSWORD)
  CONFIRM.PWD = R.NEW(LOC.CP.CONFIRM.PASSWORD)

  GOSUB VAL.PWD

  RETURN

********
VAL.PWD:
********

  ISCONSEC.VALID = 0
  NUM.CHARS = 0
  NUM.CONSEC = 3
  INT.COUNTER = 0
  INT.CNTINT = 0
  P.CHARACTER = ""
  P.CHAR.PWD = ""
  Y.CHARUPP = 0
  Y.CHARLOW = 0
  Y.CHARNUM = 0

  R.SPF= ""; SPF.ERR = ""
  CALL CACHE.READ(FN.SPF,"SYSTEM",R.SPF,SPF.ERR)
  IF R.SPF THEN
    Y.ADMIT.LENGTH = R.SPF<SPF.PASS.MIN.LENGTH>
    Y.ADMIT.UPP = R.SPF<SPF.PASS.UPPER.ALPHA>
    Y.ADMIT.LOW = R.SPF<SPF.PASS.LOWER.ALPHA>
    Y.ADMIT.NUM = R.SPF<SPF.PASS.NUMERIC>
  END

  STR.LENGTH.PWD = LEN(SRC.PWD)

  IF STR.LENGTH.PWD < Y.ADMIT.LENGTH THEN
    AF = LOC.CP.NEW.PASSWORD
    IF LNGG EQ 1 THEN
      ETEXT = "EB-LONG.CAMPO.PWD":FM:Y.ADMIT.LENGTH:" CHARACTERS"
    END ELSE
      ETEXT = "EB-LONG.CAMPO.PWD":FM:Y.ADMIT.LENGTH:" CARACTERES"
    END
    CALL STORE.END.ERROR
    RETURN
  END

  IF ISALNUM(SRC.PWD) = FALSE THEN
    AF = LOC.CP.NEW.PASSWORD
    ETEXT = "EB-VALID.PWD.ALFANUM"
    CALL STORE.END.ERROR
    RETURN
  END

  FOR INT.COUNTER = 1 TO STR.LENGTH.PWD
    P.CHARACTER = SRC.PWD[INT.COUNTER,1]
    GOSUB CHECK.CHAR
    ISCONSEC.VALID = 0
    INT.CNTINT = NUM.CHARS
    FOR INT.CNTINT = NUM.CHARS TO STR.LENGTH.PWD
      P.CHAR.PWD = SRC.PWD[INT.CNTINT,1]
      IF P.CHARACTER = P.CHAR.PWD THEN
        ISCONSEC.VALID = ISCONSEC.VALID + 1
        IF ISCONSEC.VALID = NUM.CONSEC THEN
          AF = LOC.CP.NEW.PASSWORD
          ETEXT = "EB-VALID.PWD.CONSEC"
          CALL STORE.END.ERROR
          RETURN
        END
      END
      ELSE
        BREAK
      END
      NUM.CHARS = NUM.CHARS + 1
    NEXT INT.CNTINT
  NEXT INT.COUNTER

  IF SRC.PWD <> CONFIRM.PWD THEN
    AF = LOC.CP.CONFIRM.PASSWORD
    ETEXT = "EB-VALID.PWD.CONFIRM"
    CALL STORE.END.ERROR
    RETURN
  END

  IF Y.CHARUPP LT Y.ADMIT.UPP OR Y.CHARLOW LT Y.ADMIT.LOW OR Y.CHARNUM LT Y.ADMIT.NUM THEN
    AF = LOC.CP.NEW.PASSWORD
    ETEXT = 'EB-INV.FMR.PWD'
    CALL STORE.END.ERROR
    RETURN
  END

  R.NEW(LOC.CP.NEW.PASSWORD.DEF) = SRC.PWD
  R.NEW(LOC.CP.CONFIRM.PASSWORD.DEF) = CONFIRM.PWD
  R.NEW(LOC.CP.PASSWORD.MASK) = '******'
  R.NEW(LOC.CP.NEW.PASSWORD) = ''
  R.NEW(LOC.CP.CONFIRM.PASSWORD) = ''

  RETURN

***********
CHECK.CHAR:
***********

  IF ISALPHA(P.CHARACTER) THEN
    IF ISUPPER(P.CHARACTER) THEN
      Y.CHARUPP++
    END ELSE
      Y.CHARLOW++
    END
  END

  IF ISDIGIT(P.CHARACTER) THEN
    Y.CHARNUM++
  END

  RETURN

END
