*-----------------------------------------------------------------------------
* <Rating>-91</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.UPD.NCF.UR.STK

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.L.NCF.STOCK
$INSERT I_F.USER
$INSERT I_F.REDO.NCF.STL.LIMIT
$INSERT I_F.INTERFACE.CONFIG.PRT

  GOSUB OPEN.FILES
  GOSUB GET.STK.DATA
  GOSUB SEL.TILL.USER
  GOSUB PROCESS.GRP.ID.LIST
  GOSUB WR.STK.DATA

  RETURN
*----------
OPEN.FILES:
*----------

  FN.REDO.L.NCF.STOCK = 'F.REDO.L.NCF.STOCK'
  F.REDO.L.NCF.STOCK  = ''
  CALL OPF(FN.REDO.L.NCF.STOCK,F.REDO.L.NCF.STOCK)

  FN.REDO.AA.NCF.IDS = "F.REDO.AA.NCF.IDS"
  F.REDO.AA.NCF.IDS  = ""
  CALL OPF(FN.REDO.AA.NCF.IDS,F.REDO.AA.NCF.IDS)

  FN.USER='F.USER'
  F.USER =''
  CALL OPF(FN.USER,F.USER)

  FN.REDO.NCF.STL.LIMIT='F.REDO.NCF.STL.LIMIT'
  F.REDO.NCF.STL.LIMIT =''
  CALL OPF(FN.REDO.NCF.STL.LIMIT,F.REDO.NCF.STL.LIMIT)

  RETURN
**************
GET.STK.DATA:
**************
  Y.STK.ID = 'SYSTEM'
  CALL F.READU(FN.REDO.L.NCF.STOCK,Y.STK.ID,R.NCF.STOCK,F.REDO.L.NCF.STOCK,ERR,'') 

  VAR.SER    =R.NCF.STOCK<ST.SERIES>
  VAR.BUS.DIV=R.NCF.STOCK<ST.BUSINESS.DIV>
  VAR.PECF   =R.NCF.STOCK<ST.PECF>
  VAR.AICF   =R.NCF.STOCK<ST.AICF>
  VAR.TCF    =R.NCF.STOCK<ST.TCF>

*  CALL F.READ(FN.REDO.NCF.STL.LIMIT,Y.STK.ID,R.REDO.NCF.STL.LIMIT,F.REDO.NCF.STL.LIMIT,ERR) ;*Tus Start 
CALL CACHE.READ(FN.REDO.NCF.STL.LIMIT,Y.STK.ID,R.REDO.NCF.STL.LIMIT,ERR) ; * Tus End
  RETURN
************
WR.STK.DATA:
************
  CALL F.WRITE(FN.REDO.L.NCF.STOCK,Y.STK.ID,R.NCF.STOCK)
  RETURN
*-------------------------------------------------------
SEL.TILL.USER:
*------------------------------------------------------
  Y.SEL.CMD="SELECT ":FN.USER :" WITH L.TELR.LOAN EQ TELLER"
  CALL EB.READLIST(Y.SEL.CMD,Y.USER.LIST,'',NO.OF.USER,SEL.ERR)
  Y.LOC.APP  ='USER'
  Y.LOC.FIELD='L.TELR.LOAN'
  Y.LOC.POS  =''
  CALL MULTI.GET.LOC.REF(Y.LOC.APP,Y.LOC.FIELD,Y.LOC.POS)

  Y.NCF.STK.USER=R.REDO.NCF.STL.LIMIT<RNS.LIM.USER.TYPE>

  LOCATE 'TELLER' IN Y.NCF.STK.USER<1,1> SETTING Y.NCF.STK.USER.POS THEN
    Y.MAX.LIMIT=R.REDO.NCF.STL.LIMIT<RNS.LIM.MAX.LIMIT,Y.NCF.STK.USER.POS>
  END
  Y.CNT.USER=1
  LOOP
  WHILE Y.CNT.USER LE NO.OF.USER
    Y.USER.ID  =Y.USER.LIST<Y.CNT.USER>
    GOSUB UPD.NCF.STK
    Y.CNT.USER++
  REPEAT
  RETURN

*-------------------------------------------------------
PROCESS.GRP.ID.LIST:
*-------------------------------------------------------

  Y.REC.NAME='OTHERS'
  Y.MAX.LIMIT       =''
  Y.NCF.STK.USER.POS=''
  LOCATE Y.REC.NAME IN Y.NCF.STK.USER<1,1> SETTING Y.NCF.STK.USER.POS THEN
    Y.MAX.LIMIT=R.REDO.NCF.STL.LIMIT<RNS.LIM.MAX.LIMIT,Y.NCF.STK.USER.POS>
  END
  Y.CNT.USER=1
  NO.OF.USER=500
  LOOP
  WHILE Y.CNT.USER LE NO.OF.USER
    Y.USER.ID  =Y.REC.NAME:'.':Y.CNT.USER
    GOSUB UPD.NCF.STK
    Y.CNT.USER++
  REPEAT

  Y.REC.NAME='ARCUSER'
  Y.MAX.LIMIT       =''
  Y.NCF.STK.USER.POS=''
  LOCATE Y.REC.NAME IN Y.NCF.STK.USER<1,1> SETTING Y.NCF.STK.USER.POS THEN
    Y.MAX.LIMIT=R.REDO.NCF.STL.LIMIT<RNS.LIM.MAX.LIMIT,Y.NCF.STK.USER.POS>
  END
  Y.CNT.USER=1
  NO.OF.USER=50
  LOOP
  WHILE Y.CNT.USER LE NO.OF.USER
    Y.USER.ID  =Y.REC.NAME:'.':Y.CNT.USER
    GOSUB UPD.NCF.STK
    Y.CNT.USER++
  REPEAT
  IF R.NCF.STOCK<ST.NCF.STATUS.ORG> EQ 'UNAVAILABLE' THEN
    GOSUB MAIL.ALERT
  END

  RETURN
*-------------------------------------------------------
UPD.NCF.STK:
*-------------------------------------------------------
  CALL F.READ(FN.REDO.AA.NCF.IDS,Y.USER.ID,R.NCF.IDS,F.REDO.AA.NCF.IDS,NCF.ERR)
  Y.USER.NCF.AVL=DCOUNT(R.NCF.IDS,FM)

  Y.LOOP.CNT = Y.USER.NCF.AVL+1
  LOOP
  WHILE Y.LOOP.CNT LE Y.MAX.LIMIT
    NCF.NUMBER = ""
    GOSUB NCF.GEN
    IF NCF.NUMBER THEN
      R.NCF.IDS<-1> = NCF.NUMBER
    END
    Y.LOOP.CNT++
  REPEAT
  CALL F.WRITE(FN.REDO.AA.NCF.IDS,Y.USER.ID,R.NCF.IDS)
  RETURN
*-----------------------------------------------------------------------
NCF.GEN:
*-----------------------------------------------------------------------

  IF R.NCF.STOCK<ST.QTY.AVAIL.ORG> GT '0' THEN
    VAR.SEQ.NO     = R.NCF.STOCK<ST.SEQUENCE.NO>
    NCF.NUMBER     = VAR.SER:VAR.BUS.DIV:VAR.PECF:VAR.AICF:VAR.TCF:VAR.SEQ.NO
    VAR.PREV.RANGE = R.NCF.STOCK<ST.PRE.ED.RG.OR>
    VAR.PREV.RANGE = VAR.PREV.RANGE<DCOUNT(VAR.PREV.RANGE,VM)>
    IF R.NCF.STOCK<ST.SEQUENCE.NO> EQ VAR.PREV.RANGE THEN
      R.NCF.STOCK<ST.SEQUENCE.NO>=R.NCF.STOCK<ST.L.STRT.RNGE.ORG>
    END ELSE
      R.NCF.STOCK<ST.SEQUENCE.NO>=R.NCF.STOCK<ST.SEQUENCE.NO>+1
    END
    R.NCF.STOCK<ST.SEQUENCE.NO>    = FMT(R.NCF.STOCK<ST.SEQUENCE.NO>,'8"0"R')
    R.NCF.STOCK<ST.NCF.ISSUED.ORG> = R.NCF.STOCK<ST.NCF.ISSUED.ORG>+1
    R.NCF.STOCK<ST.QTY.AVAIL.ORG>  = R.NCF.STOCK<ST.QTY.AVAIL.ORG>-1
    IF  R.NCF.STOCK<ST.QTY.AVAIL.ORG> GE R.NCF.STOCK<ST.L.MIN.NCF.ORG>  THEN
      R.NCF.STOCK<ST.NCF.STATUS.ORG>='AVAILABLE'
    END ELSE
*Mail alert part to be written
      R.NCF.STOCK<ST.NCF.STATUS.ORG>='UNAVAILABLE'
    END
  END
  RETURN
**********
MAIL.ALERT:
**********
  CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
  VAR.UNIQUE.ID=UNIQUE.TIME
  FILENAME='APAP':VAR.UNIQUE.ID:'.TXT'
  GOSUB GET.MAIL.FOLDER
  FN.HRMS.FILE = Y.MAILIN.FOLDER
  F.HRMA.FILE  =''
  CALL OPF(FN.HRMS.FILE ,F.HRMA.FILE)
  FROM.MAIL    = R.NCF.STOCK<ST.L.FROM.EMAIL.ID>
  TO.MAIL      = R.NCF.STOCK<ST.L.TO.EMAIL.ID>
  SUBJ.MAIL    = R.NCF.STOCK<ST.L.SUBJECT.MAIL>
  MSG.MAIL     = R.NCF.STOCK<ST.L.MESSAGE.MAIL>
  REC=FROM.MAIL:"#":TO.MAIL:"#":SUBJ.MAIL:"#":MSG.MAIL
  WRITE REC TO F.HRMA.FILE,FILENAME
 
  RETURN
*----------------
GET.MAIL.FOLDER:
*----------------
  R.INT.CONFIG = ''
  FN.INTERFACE.CONFIG.PRT = 'F.INTERFACE.CONFIG.PRT'
  F.INTERFACE.CONFIG.PRT = ''
  CALL OPF(FN.INTERFACE.CONFIG.PRT,F.INTERFACE.CONFIG.PRT)

  CALL CACHE.READ(FN.INTERFACE.CONFIG.PRT,"email",R.INT.CONFIG,EMAILL.ERR)
  IF R.INT.CONFIG THEN
    Y.FOLDER.TYPE = R.INT.CONFIG<INTRF.MSG.INT.FLD.NAME>
    Y.FOLDER.NAME = R.INT.CONFIG<INTRF.MSG.INT.FLD.VAL>
    CHANGE VM TO FM IN Y.FOLDER.TYPE
    CHANGE VM TO FM IN Y.FOLDER.NAME
    LOCATE "EMAIL_FOLDER_PATH" IN Y.FOLDER.TYPE SETTING TYPE.POS THEN
      Y.MAILIN.FOLDER = Y.FOLDER.NAME<TYPE.POS>
    END
    LOCATE "ERROR_FOLDER_PATH" IN Y.FOLDER.TYPE SETTING TYPE.POS THEN
      Y.ERROR.FOLDER = Y.FOLDER.NAME<TYPE.POS>
    END
  END
  RETURN
END