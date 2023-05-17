*-----------------------------------------------------------------------------
* <Rating>-62</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.SAP.GL.EXT.DET.ENC(GIT.OUT.MSG,GIT.ERR)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.SAP.GL.EXT.HDR.EXP.LOG
*--------------------------------------------------------------------------------------------------------
*Description       : This is an OUT routine, this routine is used to form the header and footer for the
*                    record output from GIT Interface
*Linked With       : GIT.TRANSPORT.FILE - SAP.NORMAL.EXTRACT-1 & SAP.REVAL.EXTRACT-1
*In  Parameter     : GIT.OUT.MSG - GIT Output Record
*Out Parameter     : GIT.OUT.MSG - GIT Output Record
*                    GIT.ERR     - GIT Error
*Files  Used       : GIT.INTERFACE.OUT                   As              I               Mode
*                    REDO.GL.H.EXTRACT.PARAMETER         As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 09 Nov 2010       Shiva Prasad Y       ODR-2009-12-0294 C.12         Initial Creation
* 03 JUN 2011       Pradeep S            PACS00072689                   Seperate GIT created for PL
*19 JUN  2011       Prabhu N             PACS00032519                  Encryption added
* 10-10-2011        PRABHU N             PACS000071961                 3DES ENCRYPTION
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.COMPANY
$INSERT I_GIT.COMMON
$INSERT I_F.GIT.INTERFACE.OUT
$INSERT I_F.GIT.TRANSPORT.FILE
$INSERT I_F.REDO.GL.H.EXTRACT.PARAMETER
$INSERT JBC.h
$INSERT I_F.REDO.INTERFACE.PARAM
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

  GOSUB OPEN.PARA
  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
  FN.GIT.INTERFACE.OUT = 'F.GIT.INTERFACE.OUT'
  F.GIT.INTERFACE.OUT = ''
  CALL OPF(FN.GIT.INTERFACE.OUT,F.GIT.INTERFACE.OUT)

  FN.REDO.GL.H.EXTRACT.PARAMETER = 'F.REDO.GL.H.EXTRACT.PARAMETER'
  F.REDO.GL.H.EXTRACT.PARAMETER = ''
  CALL OPF(FN.REDO.GL.H.EXTRACT.PARAMETER,F.REDO.GL.H.EXTRACT.PARAMETER)

  FN.COMPANY = 'F.COMPANY'
  F.COMPANY = ''
  CALL OPF(FN.COMPANY,F.COMPANY)

  FN.GIT.TRANSPORT.FILE = 'F.GIT.TRANSPORT.FILE'
  F.GIT.TRANSPORT.FILE = ''
  CALL OPF(FN.GIT.TRANSPORT.FILE,F.GIT.TRANSPORT.FILE)

  FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
  F.REDO.INTERFACE.PARAM = ""
  CALL OPF(FN.REDO.INTERFACE.PARAM, F.REDO.INTERFACE.PARAM)
  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
  CRLF=CHARX(013):CHARX(254)
  CHANGE CRLF TO FM IN GIT.OUT.MSG
  CRLF=CHARX(013):CHARX(010)
  CHANGE CRLF TO FM IN GIT.OUT.MSG

  Y.FINAL.REC= GIT.OUT.MSG
  Y.FINAL.REC.CNT=DCOUNT(Y.FINAL.REC,FM)
  Y.LOOP.FINAL.CNT=1
  LOOP
  WHILE Y.LOOP.FINAL.CNT LE Y.FINAL.REC.CNT
    R.RETURN.MESSAGE=Y.FINAL.REC<Y.LOOP.FINAL.CNT>
    Y.RECORD.LINE=R.RETURN.MESSAGE
    GOSUB INITIALIZE.ENCRYPT
    GOSUB OPEN.FILES.ENCRYPT
    GOSUB PROCESS.ENCRYPT
    Y.ENCRP.REC<Y.LOOP.FINAL.CNT> = Y.RECORD.LINE
    Y.LOOP.FINAL.CNT++
  REPEAT
  GIT.OUT.MSG=Y.ENCRP.REC
  RETURN
*--------------------------------------------------------------------------------------------------------
*************************
INITIALIZE.ENCRYPT:
*************************
  Y.ERR = ''
  Y.PARAM.ID = "DES333"
  R.REDO.INTERFACE.PARAM = ""
  GOAHEAD = ''
  RETURN
*************************
OPEN.FILES.ENCRYPT:
*************************
  yLine=''
  CALL F.READ(FN.REDO.INTERFACE.PARAM, Y.PARAM.ID, R.REDO.INTERFACE.PARAM, F.REDO.INTERFACE.PARAM, Y.ERR)
  IF NOT(R.REDO.INTERFACE.PARAM) THEN
    RETURN
  END
  GOAHEAD = 'TRUE'
  yEncripKey = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.ENCRIP.KEY>
  yLine = R.RETURN.MESSAGE

  RETURN
*************************
PROCESS.ENCRYPT:
*************************
*PACS00071961-S
  IF R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.ENCRIPTATION> EQ 'SI' THEN
    yLine = ENCRYPT(R.RETURN.MESSAGE,yEncripKey,JBASE_CRYPT_3DES_BASE64)
*PACS00071961-E
  END ELSE
    yLine = R.RETURN.MESSAGE
  END

  Y.RECORD.LINE=yLine
  RETURN
*--------------------------------------------------------------------------------------------------------
END
