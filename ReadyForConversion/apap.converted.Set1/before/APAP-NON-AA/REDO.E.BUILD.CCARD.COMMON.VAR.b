*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BUILD.CCARD.COMMON.VAR(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.E.BUILD.CHECK.COMMON.VAR
*----------------------------------------------------------

* Description   : Used to get current Account

* Linked with   : Enquiry
* In Parameter  : None
* Out Parameter : None
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*07.04.2011     PACS00036498           Prabhu N            INITIAL CREATION
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_System
    $INSERT I_F.CUSTOMER.ACCOUNT

    GOSUB INIT
    GOSUB PROCESS
    RETURN
*-----
INIT:
*-----
  F.CUSTOMER.ACCOUNT = ''
  FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
  CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

  FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
  F.REDO.EB.USER.PRINT.VAR=''
  CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)

  Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")
  Y.USR.VAR = Y.USR.VAR:"-":"CURRENT.CARD.LIST.CUS"

  RETURN
*-------
PROCESS:
*-------
  Y.CURRENT.CARD.ID = System.getVariable("CURRENT.CARD.ID")
  Y.CURRENT.CARD.LIST = System.getVariable("CURRENT.CARD.LIST")
  
  *READ CARD.DATA FROM F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR THEN ;*Tus Start 
  CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,CARD.DATA,F.REDO.EB.USER.PRINT.VAR,CARD.DATA.ERR)
  IF CARD.DATA THEN  ;* Tus End
    CHANGE '*' TO FM IN CARD.DATA
    IF NUM(Y.CURRENT.CARD.ID) THEN
      LOCATE Y.CURRENT.CARD.ID IN CARD.DATA SETTING CUS.ACCT.POS THEN

      END ELSE
        ENQ.ERROR = 'OF-SECURITY.VIOLATION'
        CALL AI.REDO.KILL.SESSION
      END
    END

    IF NUM(Y.CURRENT.CARD.LIST) THEN
      LOCATE Y.CURRENT.CARD.LIST IN CARD.DATA SETTING CUS.ACCT.POS THEN
      END ELSE
        ENQ.ERROR = 'OF-SECURITY.VIOLATION'
        CALL AI.REDO.KILL.SESSION
      END
    END

  END ELSE
    ENQ.ERROR = 'OF-SECURITY.VIOLATION'
    CALL AI.REDO.KILL.SESSION
  END
  RETURN
END
