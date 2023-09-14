* @ValidationCode : MjoyMDE0MTIxMTMwOkNwMTI1MjoxNjgwNjc4OTg2NDE2OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 12:46:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.INP.CPH.OPEN
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.APAP.INP.CPH.OPEN
* ODR NO      : ODR-2009-10-0346
*----------------------------------------------------------------------
*DESCRIPTION: REDO.APAP.INP.CPH.OPEN is an input routine for the version AZ.ACCOUNT,
* OPEN.CPH which populates table REDO.MORTGAGES.DET with the linked deposit details




*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: AZ.ACCOUNT
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*27.07.2010  H GANESH        ODR-2009-10-0346  INITIAL CREATION
* Date                   who                   Reference              
* 05-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION FM TO @FM VM TO @VM AND SM TO @SM AND ++ TO += 1
* 05-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.REDO.APAP.MORTGAGES.DETAIL
    $INSERT I_F.REDO.APAP.CPH.PARAMETER
    $INSERT I_F.REDO.OFS.PARAM


    GOSUB INIT
    GOSUB OPENFILES
    GOSUB MULTI.GET.REF
    GOSUB CHECK.DUP
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    Y.MAT.AMT=''
    R.REDO.APAP.MORTGAGES.DETAIL=''

RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
* This part open all the reqiured files

    FN.REDO.APAP.MORTGAGES.DETAIL='F.REDO.APAP.MORTGAGES.DETAIL'
    F.REDO.APAP.MORTGAGES.DETAIL=''
    CALL OPF(FN.REDO.APAP.MORTGAGES.DETAIL,F.REDO.APAP.MORTGAGES.DETAIL)

    FN.REDO.APAP.CPH.PARAMETER='F.REDO.APAP.CPH.PARAMETER'

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.OFS.PARAM='F.REDO.OFS.PARAM'

    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT=''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

RETURN

*----------------------------------------------------------------------
MULTI.GET.REF:
*----------------------------------------------------------------------
* This part gets the local field position in LRT

    LOC.REF.APPLICATION="AZ.ACCOUNT":@FM:"AA.PRD.DES.ACCOUNT":@FM:"ACCOUNT"
    LOC.REF.FIELDS='L.MG.ACT.NO':@VM:'L.AZ.REF.NO':@VM:'L.TYPE.INT.PAY':@FM:'L.TRANSF.STATUS':@FM:"L.AC.PAYMT.MODE":@VM:'L.AC.REINVESTED'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.MG.ACT.NO=LOC.REF.POS<1,1>
    POS.L.AZ.REF.NO=LOC.REF.POS<1,2>
    POS.L.TYPE.INT.PAY=LOC.REF.POS<1,3>
    POS.L.TRANSF.STATUS=LOC.REF.POS<2,1>
    POS.L.AC.PAYMT.MODE=LOC.REF.POS<3,1>
    POS.L.AC.REINVESTED=LOC.REF.POS<3,2>
RETURN
*----------------------------------------------------------------------
CHECK.DUP:
*----------------------------------------------------------------------
    Y.ARRAY = ''
    Y.LOAN.NO = R.NEW(AZ.LOCAL.REF)<1,POS.L.MG.ACT.NO>

    CHANGE @SM TO @FM IN Y.LOAN.NO
    CHANGE @VM TO @FM IN Y.LOAN.NO
    Y.LOAN.CNT = DCOUNT(Y.LOAN.NO,@FM)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.LOAN.CNT
        Y.NO = Y.LOAN.NO<Y.VAR1>
        LOCATE Y.NO IN Y.ARRAY SETTING POS THEN
            AF = AZ.LOCAL.REF
            AV = POS.L.MG.ACT.NO
            AS = Y.VAR1
            ETEXT = 'EB-REDO.LOAN.NO.DUP'
            CALL STORE.END.ERROR

        END ELSE
            Y.ARRAY<-1> = Y.NO
        END
        Y.VAR1 += 1 ;*R22 AUTO CONVERSTION ++ TO += 1
    REPEAT

RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
*R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.REF.NO>='AZ-':ID.NEW
    GOSUB READ.ACCOUNT
    Y.INT.PAY.MODE=R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.PAYMT.MODE>
    IF Y.INT.PAY.MODE EQ 'Admin.check' THEN
        R.NEW(AZ.LOCAL.REF)<1,POS.L.TYPE.INT.PAY>='Admin.check'
    END
    IF Y.INT.PAY.MODE EQ 'Transfer.via.ACH' THEN
        R.NEW(AZ.LOCAL.REF)<1,POS.L.TYPE.INT.PAY>='Transfer.via.ACH'
    END
    IF R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.REINVESTED> EQ 'YES' THEN
        R.NEW(AZ.LOCAL.REF)<1,POS.L.TYPE.INT.PAY>='Reinvested'
    END



    Y.L.MG.ACT.NO=R.NEW(AZ.LOCAL.REF)<1,POS.L.MG.ACT.NO>
    IF NOT(Y.L.MG.ACT.NO) THEN
        RETURN
    END
    Y.L.MG.ACT.NO.CNT=DCOUNT(Y.L.MG.ACT.NO,@SM)

    VAR1=1
    LOOP
    WHILE VAR1 LE Y.L.MG.ACT.NO.CNT
        Y.MSG.DET.ID= FIELD(Y.L.MG.ACT.NO,@SM,VAR1)
        GOSUB READ.MORTGAGES.DET
        CALL F.WRITE(FN.REDO.APAP.MORTGAGES.DETAIL,Y.MSG.DET.ID,R.REDO.APAP.MORTGAGES.DETAIL)
        VAR1 += 1
    REPEAT
RETURN
*----------------------------------------------------------------------
READ.MORTGAGES.DET:
*----------------------------------------------------------------------

    CALL F.READ(FN.REDO.APAP.MORTGAGES.DETAIL,Y.MSG.DET.ID,R.REDO.APAP.MORTGAGES.DETAIL,F.REDO.APAP.MORTGAGES.DETAIL,MRTG.ERR)
    Y.DEP.AC.NOS=R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.DEP.ACT.NO>
    CHANGE @VM TO @FM IN Y.DEP.AC.NOS
    ARR.ID=R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.ARR.ID>
    LOCATE ID.NEW IN Y.DEP.AC.NOS SETTING POS1 THEN
        Y.FLD.VALUE=POS1
    END ELSE
        Y.FLD.VALUE=DCOUNT(Y.DEP.AC.NOS,@VM)+1
    END
    IF V$FUNCTION EQ 'D' OR V$FUNCTION EQ 'R' THEN
        GOSUB CLEAR.DEP.DETAILS
        Y.TRANSFER.STATUS='NULL'
        GOSUB UPD.TRANSFER.STATUS
        RETURN
    END
    IF V$FUNCTION EQ 'I' THEN
        GOSUB ASSIGN.VAUES
        Y.TRANSFER.STATUS='TRANSFERRED'
        GOSUB UPD.TRANSFER.STATUS
    END
RETURN

*----------------------------------------------------------------------
CLEAR.DEP.DETAILS:
*----------------------------------------------------------------------

    DEL R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.DEP.ACT.NO,Y.FLD.VALUE>
    DEL R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.DEP.ACT.NAME,Y.FLD.VALUE>
    DEL R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.START.DATE,Y.FLD.VALUE>
    DEL R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.END.DATE,Y.FLD.VALUE>
    DEL R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.MATURITY.AMT,Y.FLD.VALUE>
    GOSUB UPD.LIEN.AMT.AND.BAL.PRIN
RETURN

*----------------------------------------------------------------------
UPD.TRANSFER.STATUS:
*----------------------------------------------------------------------

*EFF.DATE = ''
*PROP.CLASS='ACCOUNT'
*PROPERTY = ''
*R.CONDITION = ''
*ERR.MSG = ''
*CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
    R.CONDITION = ''
    R.CONDITION<AA.AC.LOCAL.REF,POS.L.TRANSF.STATUS>=Y.TRANSFER.STATUS
    GOSUB OFS.UPDATE
RETURN

*----------------------------------------------------------------------
ASSIGN.VAUES:
*----------------------------------------------------------------------

    R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.DEP.ACT.NO,Y.FLD.VALUE>=ID.NEW
    R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.DEP.ACT.NAME,Y.FLD.VALUE>=Y.ACT.NAME
    R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.START.DATE,Y.FLD.VALUE>=R.NEW(AZ.VALUE.DATE)
    R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.END.DATE,Y.FLD.VALUE>=R.NEW(AZ.MATURITY.DATE)
    CALL REDO.APAP.GET.MATURITY.AMT(ID.NEW,Y.MAT.AMT)
    R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.MATURITY.AMT,Y.FLD.VALUE>=Y.MAT.AMT
    GOSUB UPD.LIEN.AMT.AND.BAL.PRIN
RETURN
*----------------------------------------------------------------------
READ.ACCOUNT:
*----------------------------------------------------------------------
    CALL F.READ(FN.ACCOUNT,ID.NEW,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.ACT.NAME=R.ACCOUNT<AC.SHORT.TITLE>
RETURN
*----------------------------------------------------------------------
UPD.LIEN.AMT.AND.BAL.PRIN:
*----------------------------------------------------------------------
    Y.PARA.ID='SYSTEM'
    CALL CACHE.READ(FN.REDO.APAP.CPH.PARAMETER,Y.PARA.ID,R.REDO.APAP.CPH.PARAMETER,PARA.ERR)
    Y.EXCESS.PERC=R.REDO.APAP.CPH.PARAMETER<CPH.PARAM.EXCESS.PERCENTAGE>
    Y.TOT.MAT=SUM(R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.MATURITY.AMT>)
    Y.LIEN.AMT=Y.TOT.MAT + ( Y.TOT.MAT * Y.EXCESS.PERC/100 )
    R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.LIEN.AMT>=Y.LIEN.AMT
    Y.BAL.PRINC=R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.OUTS.PRINCIPLE>-Y.LIEN.AMT
    R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.BAL.PRINCIPAL>=Y.BAL.PRINC
RETURN
*----------------------------------------------------------------------
OFS.UPDATE:
*----------------------------------------------------------------------

    IN.PROPERTY.CLASS='ACCOUNT'
    OUT.PROPERTY=''
    CALL REDO.GET.PROPERTY.NAME(ARR.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)

    Y.PROPERTY = OUT.PROPERTY
    Y.ACTIVITY = "LENDING-UPDATE-":OUT.PROPERTY


    APP.NAME = 'AA.ARR.ACCOUNT'
    OFSFUNCT=''
    PROCESS  = ''
    OFSVERSION = ''
    GTSMODE = ''
    TRANSACTION.ID=''
    OFSRECORD = ''
    OFS.MSG.ID =''
    OFS.ERR = ''
    NO.OF.AUTH=0

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
        IF OFSRECORD<VAR2> THEN
            OFS.STRING:='FIELD.NAME:1:':VAR2:'=':FIELD(OFSRECORD<VAR2>,'=',1):','
            OFS.STRING:='FIELD.VALUE:1:':VAR2:'=':FIELD(OFSRECORD<VAR2>,'=',2):','
        END
        VAR2 += 1  ;*R22 AUTO CONVERSTION ++ TO += 1
    REPEAT

    OFS.MSG="AA.ARRANGEMENT.ACTIVITY,APAP/I/PROCESS,,,ARRANGEMENT:1:1=":ARR.ID:",ACTIVITY:1:1=":Y.ACTIVITY:',PROPERTY:1:1=':Y.PROPERTY:',':OFS.STRING

    OFS.SRC = 'REDO.AZ.CPH'
    OFS.MSG.ID = ''
    OPTIONS = ''
    CALL OFS.POST.MESSAGE(OFS.MSG,OFS.MSG.ID,OFS.SRC,OPTIONS)

RETURN

END
