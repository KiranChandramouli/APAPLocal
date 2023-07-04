* @ValidationCode : MjotNzAwMDY3MjY3OkNwMTI1MjoxNjg1NTQ0MDc1Nzc5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 20:11:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.AUT.CPH.CANCEL
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.AUT.CPH.CANCEL
*------------------------------------------------------------------------------

*Description  : REDO.APAP.INP.CPH.CANCEL is an input routine for the version
*               AZ.ACCOUNT,CLOSE.CPH which updates table
*               REDO.APAP.MORTGAGE.DETAILS
*Linked With  : AZ.ACCOUNT,CLOSE.CPH
*In Parameter : N/A
*Out Parameter: N/A
*Linked File  : REDO.PAP.MORTGAGES.DETAIL

*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 05-08-2010       JEEVA T            ODR-2009-10-0346         Initial Creation
* Date                   who                   Reference
* 04-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION VM TO @VM AND FM TO @FM AND VAR2++ TO VAR += 1
* 04-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.REDO.APAP.CPH.DETAIL
    $INSERT I_F.REDO.APAP.CPH.PARAMETER
    $INSERT I_F.REDO.OFS.PARAM
    $USING APAP.TAM
    $USING APAP.AA
*--------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
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
************
PROCESS.PARA:
************
    Y.CPH.DET.ID=ID.NEW

    GOSUB READ.CPH.DET
    Y.ARR.ID=R.CPH.DETAIL<CPH.DET.ARR.ID>
    Y.ARR.ID.CNT=DCOUNT(Y.ARR.ID,@VM)
    VAR1=1
    CHANGE @VM TO @FM IN Y.ARR.ID
    LOOP
    WHILE VAR1 LE Y.ARR.ID.CNT
        ARR.ID=Y.ARR.ID<VAR1>
        Y.TRANSFER.STATUS=''
        GOSUB WRITE.TRANSF.STATUS
        VAR1+=1
    REPEAT
    GOSUB WRITE.CPH.DET

RETURN
*--------------------------------------------------------------------------------
************
READ.CPH.DET:
************
    CALL F.READ(FN.REDO.APAP.CPH.DETAIL,Y.CPH.DET.ID,R.CPH.DETAIL,F.REDO.APAP.CPH.DETAIL,Y.REDO.APAP.CPH.DETAIL.ERR)
RETURN
*--------------------------------------------------------------------------------
********************
FIND.MULTI.LOCAL.REF:
********************
    APPL.ARRAY='AZ.ACCOUNT':@FM:'AA.PRD.DES.ACCOUNT'
    FLD.ARRAY='L.VAL.MAT.DATE':@FM:'L.TRANSF.STATUS'
    FLD.POS=''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.VAL.MAT.DATE.POS=FLD.POS<1,1>
    POS.L.TRANSF.STATUS=FLD.POS<2,1>
RETURN
**************************************************************************
*************
WRITE.CPH.DET:
*************
    REDO.APAP.CPH.DETAIL.HIS.ID = ID.NEW:';':R.CPH.DETAIL<CPH.DET.CURR.NO>
    R.REDO.APAP.CPH.DETAIL.HIS = R.CPH.DETAIL
    CALL F.WRITE(FN.REDO.APAP.CPH.DETAIL.HIS,REDO.APAP.CPH.DETAIL.HIS.ID,R.REDO.APAP.CPH.DETAIL.HIS)
    CALL F.DELETE(FN.REDO.APAP.CPH.DETAIL,Y.CPH.DET.ID)

RETURN
*--------------------------------------------------------------------------------
*******************
WRITE.TRANSF.STATUS:
*******************
    EFF.DATE = ''
    PROP.CLASS='ACCOUNT'
    PROPERTY = ''
    R.CONDITION = ''
    ERR.MSG = ''
    APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
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
        VAR2 += 1   ;*R22 AUTO CONVERSTION VAR2++ TO VAR += 1
    REPEAT

    CALL CACHE.READ(FN.REDO.OFS.PARAM,ID.COMPANY,R.REDO.OFS.PARAM,PARAM.ERR)
    Y.USERNAME= R.REDO.OFS.PARAM<REDO.OFS.USER.NAME>
    Y.PASSWORD= R.REDO.OFS.PARAM<REDO.OFS.USER.PASSWORD>
    OFS.SRC= R.REDO.OFS.PARAM<REDO.OFS.OFS.SOURCE.ID>
    IN.PROPERTY.CLASS='ACCOUNT'
    OUT.PROPERTY=''
    R.OUT.AA.RECORD=''
    OUT.ERR=''

    APAP.TAM.redoGetPropertyName(ARR.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR);* R22 Manual conversion
    CALL F.READ(FN.AA.ARRANGEMENT,ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
    OFS.STRING.FINAL='AA.ARRANGEMENT.ACTIVITY,APAP/I/PROCESS,':Y.USERNAME:'/':Y.PASSWORD:",,ARRANGEMENT:1:1=":ARR.ID:",ACTIVITY:1:1=LENDING-UPDATE-ACCOUNT,EFFECTIVE.DATE:1:1=":TODAY:',CUSTOMER:1:1=':R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>:',CURRENCY:1:1=':R.AA.ARRANGEMENT<AA.ARR.CURRENCY>:',PRODUCT:1:1=':R.AA.ARRANGEMENT<AA.ARR.PRODUCT>:',PROPERTY:1:1=':OUT.PROPERTY:',':OFS.STRING
    CALL OFS.POST.MESSAGE(OFS.STRING.FINAL,OFS.MSG.ID,OFS.SRC,OPTIONS)

RETURN
*--------------------------------------------------------------------------------
END
