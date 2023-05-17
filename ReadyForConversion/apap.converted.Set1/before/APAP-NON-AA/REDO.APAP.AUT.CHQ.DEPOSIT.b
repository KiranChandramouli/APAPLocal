*-----------------------------------------------------------------------------
* <Rating>-130</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.AUT.CHQ.DEPOSIT
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.AUT.CHQ.DEPOSIT
*--------------------------------------------------------------------------------------------------------
*Description       : This is an AUTHORISATION routine, the routine checks if the transaction type is
*                    CHEQUE DEPOSIT then updates the table REDO.H.CLEARING.OUTWARD with account,
*                    cheque amount, transaction reference and number of cheques
*Linked With       : Version T24.FUND.SERVICES,REDO.MULTI.TXN
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : T24.FUND.SERVICES                   As          I       Mode
*                    REDO.H.CLEARING.OUTWARD             As          I-O     Mode
*                    AC.LOCKED.EVENTS                    As          I       Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                 Description
*   ------             -----               -------------              -------------
* 19 July 2010     Shiva Prasad Y      ODR-2009-10-0318 B.126        Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.T24.FUND.SERVICES
$INSERT I_F.REDO.H.CLEARING.OUTWARD
$INSERT I_F.AC.LOCKED.EVENTS
$INSERT I_F.USER
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
* In this para of the code, file variables are initialised and opened
  FN.REDO.H.CLEARING.OUTWARD = 'F.REDO.H.CLEARING.OUTWARD'
  F.REDO.H.CLEARING.OUTWARD  = ''
  CALL OPF(FN.REDO.H.CLEARING.OUTWARD,F.REDO.H.CLEARING.OUTWARD )

  FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
  F.AC.LOCKED.EVENTS  = ''
  CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
  Y.TXN.CODES = R.NEW(TFS.TRANSACTION)
  Y.FLAG  = ''

  LOCATE 'CHQDEP' IN Y.TXN.CODES<1,1> SETTING Y.TXN.POS THEN
    Y.FLAG += 1
    GOSUB UPDATED.CLEARING.OUTWARD
    GOSUB HOLD.ON.AMOUNT
  END

  RETURN
*--------------------------------------------------------------------------------------------------------
*************************
UPDATED.CLEARING.OUTWARD:
*************************
* In this para of the code, the local template REDO.H.CLEARING.OUTWARD is being updated
  GOSUB FIND.MULTI.LOCAL.REF
  REDO.H.CLEARING.OUTWARD.ID = ID.NEW

  GOSUB READ.REDO.H.CLEARING.OUTWARD

  R.REDO.H.CLEARING.OUTWARD<REDO.CLR.OUT.TRANS.REFERENCE> = ID.NEW
  R.REDO.H.CLEARING.OUTWARD<REDO.CLR.OUT.ACCOUNT.NUMBER>  = R.NEW(TFS.PRIMARY.ACCOUNT)
  R.REDO.H.CLEARING.OUTWARD<REDO.CLR.OUT.AMOUNT>          = R.NEW(TFS.AMOUNT)<1,Y.TXN.POS>
  R.REDO.H.CLEARING.OUTWARD<REDO.CLR.OUT.CURRENCY>        = R.NEW(TFS.CURRENCY)<1,Y.TXN.POS>
  R.REDO.H.CLEARING.OUTWARD<REDO.CLR.OUT.NO.OF.CHEQUE>    = R.NEW(TFS.LOCAL.REF)<1,LOC.L.TT.NO.OF.CHQ.POS,Y.FLAG>
  R.REDO.H.CLEARING.OUTWARD<REDO.CLR.OUT.USER.ID>         = OPERATOR

  GOSUB UPDATE.AUDIT.FIELDS

  GOSUB WRITE.REDO.H.CLEARING.OUTWARD

  RETURN
*--------------------------------------------------------------------------------------------------------
********************
UPDATE.AUDIT.FIELDS:
********************
  R.REDO.H.CLEARING.OUTWARD<REDO.CLR.OUT.INPUTTER>   = TNO:'_':OPERATOR

  Y.TEMP.TIME = OCONV(TIME(),"MTS")
  Y.TEMP.TIME = Y.TEMP.TIME[1,5]
  CHANGE ':' TO '' IN Y.TEMP.TIME
  Y.CHECK.DATE = DATE()

  Y.DATE.TIME = OCONV(Y.CHECK.DATE,"DY2"):FMT(OCONV(Y.CHECK.DATE,"DM"),'R%2'):FMT(OCONV(Y.CHECK.DATE,"DD"),'R%2'):Y.TEMP.TIME

  R.REDO.H.CLEARING.OUTWARD<REDO.CLR.OUT.DATE.TIME>  = Y.DATE.TIME
  R.REDO.H.CLEARING.OUTWARD<REDO.CLR.OUT.AUTHORISER> = TNO:'_':OPERATOR
  R.REDO.H.CLEARING.OUTWARD<REDO.CLR.OUT.CO.CODE>    = ID.COMPANY
  R.REDO.H.CLEARING.OUTWARD<REDO.CLR.OUT.DEPT.CODE>  = R.USER<EB.USER.DEPARTMENT.CODE>

  RETURN
*--------------------------------------------------------------------------------------------------------
***************
HOLD.ON.AMOUNT:
***************
* In this para of the code, a hold is raised on the amount
  R.AC.LOCKED.EVENTS<AC.LCK.ACCOUNT.NUMBER> = R.NEW(TFS.PRIMARY.ACCOUNT)<1,Y.TXN.POS>
  R.AC.LOCKED.EVENTS<AC.LCK.FROM.DATE>      = R.NEW(TFS.CR.VALUE.DATE)<1,Y.TXN.POS>
  R.AC.LOCKED.EVENTS<AC.LCK.LOCKED.AMOUNT>   = R.NEW(TFS.AMOUNT)<1,Y.TXN.POS>
  R.AC.LOCKED.EVENTS<AC.LCK.LOCAL.REF,LOC.L.AC.CLR.REF.POS> = ID.NEW
  GOSUB RAISE.OFS.MESSAGE

  RETURN
*--------------------------------------------------------------------------------------------------------
******************
RAISE.OFS.MESSAGE:
******************
* In this para of the code, the OFS message is raised here
  OFS.SOURCE.ID  = 'OFSUPDATE'
  APP.NAME       = 'AC.LOCKED.EVENTS'
  OFSFUNCT       = 'I'
  PROCESS        = 'PROCESS'
  OFSVERSION     = 'AC.LOCKED.EVENTS,REDO.B126'
  GTSMODE        = ''
  NO.OF.AUTH     = 0
  TRANSACTION.ID = ''
  OFSRECORD     = ''

  CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.AC.LOCKED.EVENTS,OFSRECORD)

  OFS.MSG.ID  = ''
  OFS.MSG.ERR = ''

  CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.MSG.ERR)

  RETURN
*--------------------------------------------------------------------------------------------------------
********************
FIND.MULTI.LOCAL.REF:
********************
* In this para of the code, local reference field positions are obtained
  APPL.ARRAY = 'T24.FUND.SERVICES':FM:'AC.LOCKED.EVENTS'
  FLD.ARRAY = 'L.TT.NO.OF.CHQ':FM:'L.AC.CLR.REF'
  FLD.POS = ''
  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
  LOC.L.TT.NO.OF.CHQ.POS  = FLD.POS<1,1>
  LOC.L.AC.CLR.REF.POS    = FLD.POS<2,1>

  RETURN
*--------------------------------------------------------------------------------------------------------
*****************************
READ.REDO.H.CLEARING.OUTWARD:
*****************************
* In this para of the code, file REDO.H.CLEARING.OUTWARD is read
  R.REDO.H.CLEARING.OUTWARD  = ''
  REDO.H.CLEARING.OUTWARD.ER = ''
  CALL F.READ(FN.REDO.H.CLEARING.OUTWARD,REDO.H.CLEARING.OUTWARD.ID,R.REDO.H.CLEARING.OUTWARD,F.REDO.H.CLEARING.OUTWARD,REDO.H.CLEARING.OUTWARD.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
******************************
WRITE.REDO.H.CLEARING.OUTWARD:
******************************
* In this para of the code, values are written to file REDO.H.CLEARING.OUTWARD
  CALL F.WRITE(FN.REDO.H.CLEARING.OUTWARD,REDO.H.CLEARING.OUTWARD.ID,R.REDO.H.CLEARING.OUTWARD)

  RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of PRogram
