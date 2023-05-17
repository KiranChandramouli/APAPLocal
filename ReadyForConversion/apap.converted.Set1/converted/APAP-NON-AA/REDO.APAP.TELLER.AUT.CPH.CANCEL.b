SUBROUTINE REDO.APAP.TELLER.AUT.CPH.CANCEL
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.TELLER.AUT.CPH.CANCEL
*------------------------------------------------------------------------------
*Description  : REDO.APAP.TELLER.AUT.CPH.CANCEL is an authorisation routine for
*               the version TELLER, CLOSE.CPH which is used to move the record
*               associated with CPH in the table REDO.APAP.CPH.DETAILS to history
*
*
*Linked With  : TELLER,CLOSE.CPH
*In Parameter : N/A
*Out Parameter: N/A
*Linked File  : REDO.APAP.CPH.DET,F.ACCOUNT,F.TELLER
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------          ------               -------------            -------------
* 20-08-2010        JEEVA T         ODR-2009-10-0346 B.21       Initial Creation
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.REDO.APAP.CPH.DETAIL
    $INSERT I_F.REDO.APAP.CPH.PARAMETER
    $INSERT I_F.REDO.OFS.PARAM
*--------------------------------------------------------------------------------
**********
MAIN.PARA:
*********
    GOSUB OPEN.PARA
    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB PROCESS.PARA
RETURN

*--------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
    FN.REDO.APAP.CPH.DETAIL='F.REDO.APAP.CPH.DETAIL'
    F.REDO.APAP.CPH.DETAIL=''
    R.CPH.DETAIL=''
    Y.REDO.APAP.CPH.DETAIL.ERR=''
    RECORD.LENGTH=''
    CALL OPF(FN.REDO.APAP.CPH.DETAIL,F.REDO.APAP.CPH.DETAIL)

    FN.REDO.OFS.PARAM='F.REDO.OFS.PARAM'

    FN.REDO.APAP.MORTGAGES.DETAIL='F.REDO.APAP.MORTGAGES.DETAIL'
    F.REDO.APAP.MORTGAGES.DETAIL =''

    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT=''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.REDO.APAP.CPH.DETAIL.HIS='F.REDO.APAP.CPH.DETAIL$HIS'
    F.REDO.APAP.CPH.DETAIL.HIS=''
    CALL OPF(FN.REDO.APAP.CPH.DETAIL.HIS,F.REDO.APAP.CPH.DETAIL.HIS)

RETURN
*--------------------------------------------------------------------------------
**********
PROCESS.PARA:
**********
    Y.CPH.DET.ID=R.NEW(TT.TE.ACCOUNT.2)
    GOSUB READ.CPH.DET
    Y.ARR.ID=R.CPH.DETAIL<CPH.DET.ARR.ID>
    Y.ARR.ID.CNT=DCOUNT(Y.ARR.ID,@VM)
    CHANGE @VM TO @FM IN Y.ARR.ID
    VAR1=1

    LOOP
    WHILE VAR1 LE Y.ARR.ID.CNT
        ARR.ID=Y.ARR.ID<VAR1>
        Y.TRANSFER.STATUS=''
        GOSUB WRITE.TRANSF.STATUS
        GOSUB WRITE.CPH.DET
        VAR1 += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------
**********
READ.CPH.DET:
**********
    CALL F.READ(FN.REDO.APAP.CPH.DETAIL,Y.CPH.DET.ID,R.CPH.DETAIL,F.REDO.APAP.CPH.DETAIL,Y.REDO.APAP.CPH.DETAIL.ERR)
RETURN
*--------------------------------------------------------------------------------
*************
FIND.MULTI.LOCAL.REF:
*************
    APPL.ARRAY='AZ.ACCOUNT':@FM:'AA.PRD.DES.ACCOUNT'
    FLD.ARRAY='L.VAL.MAT.DATE':@FM:'L.TRANSF.STATUS'
    FLD.POS=''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.VAL.MAT.DATE.POS=FLD.POS<1,1>
    POS.L.TRANSF.STATUS=FLD.POS<2,1>
RETURN
**************************************************************************
**********
WRITE.CPH.DET:
**********
    REDO.APAP.CPH.DETAIL.HIS.ID=Y.CPH.DET.ID:';':R.CPH.DETAIL<CPH.DET.CURR.NO>
    R.REDO.APAP.CPH.DETAIL.HIS=R.CPH.DETAIL
    CALL F.WRITE(FN.REDO.APAP.CPH.DETAIL.HIS,REDO.APAP.CPH.DETAIL.HIS.ID,R.REDO.APAP.CPH.DETAIL.HIS)
    CALL F.DELETE(FN.REDO.APAP.CPH.DETAIL,Y.CPH.DET.ID)
RETURN
*--------------------------------------------------------------------------------
**********
WRITE.TRANSF.STATUS:
**********
    EFF.DATE = ''
    PROP.CLASS='ACCOUNT'
    PROPERTY = ''
    R.CONDITION = ''
    ERR.MSG = ''
    CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
    R.CONDITION<AA.AC.LOCAL.REF,POS.L.TRANSF.STATUS>=Y.TRANSFER.STATUS


    APP.NAME = 'AA.ARR.ACCOUNT'
    OFSFUNCT=''
    PROCESS  = ''
    OFSVERSION = ''
    GTSMODE = ''
    TRANSACTION.ID=''
    OFSRECORD = ''
    OFS.MSG.ID =''
    OFS.ERR = ''
    NO.OF.AUTH =''
    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.CONDITION,OFSRECORD)
    CHANGE ',' TO @FM IN OFSRECORD
    DEL OFSRECORD<1>
    DEL OFSRECORD<1>
    DEL OFSRECORD<1>
    FIELD.COUNT=DCOUNT(OFSRECORD,@FM)
    OFS.STRING=''
    VAR2=1
    LOOP
    WHILE VAR2 LE FIELD.COUNT
        OFS.STRING:='FIELD.NAME:1:':VAR2:'=':FIELD(OFSRECORD<VAR2>,'=',1):','
        OFS.STRING:='FIELD.VALUE:1:':VAR2:'=':FIELD(OFSRECORD<VAR2>,'=',2):','
        VAR2 += 1
    REPEAT

    CALL CACHE.READ(FN.REDO.OFS.PARAM,ID.COMPANY,R.REDO.OFS.PARAM,PARAM.ERR)
    Y.USERNAME= R.REDO.OFS.PARAM<REDO.OFS.USER.NAME>
    Y.PASSWORD= R.REDO.OFS.PARAM<REDO.OFS.USER.PASSWORD>
    OFS.SRC= R.REDO.OFS.PARAM<REDO.OFS.OFS.SOURCE.ID>
    IN.PROPERTY.CLASS='ACCOUNT'
    OUT.PROPERTY=''
    R.OUT.AA.RECORD=''
    OUT.ERR=''

    CALL REDO.GET.PROPERTY.NAME(ARR.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)
    CALL F.READ(FN.AA.ARRANGEMENT,ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
    OFS.STRING.FINAL='AA.ARRANGEMENT.ACTIVITY,APAP/I/PROCESS,':Y.USERNAME:'/':Y.PASSWORD:",,ARRANGEMENT:1:1=":ARR.ID:",ACTIVITY:1:1=LENDING-UPDATE-ACCOUNT,EFFECTIVE.DATE:1:1=":TODAY:',CUSTOMER:1:1=':R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>:',CURRENCY:1:1=':R.AA.ARRANGEMENT<AA.ARR.CURRENCY>:',PRODUCT:1:1=':R.AA.ARRANGEMENT<AA.ARR.PRODUCT>:',PROPERTY:1:1=':OUT.PROPERTY:',':OFS.STRING
    CALL OFS.POST.MESSAGE(OFS.STRING.FINAL,OFS.MSG.ID,OFS.SRC,OPTIONS)

RETURN
*--------------------------------------------------------------------------------
END
