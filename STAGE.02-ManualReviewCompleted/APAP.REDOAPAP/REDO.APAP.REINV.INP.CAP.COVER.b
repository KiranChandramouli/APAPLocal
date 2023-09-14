* @ValidationCode : MjoxNTYxMzA3MjQyOkNwMTI1MjoxNjgxODAwNzgwNzQ3OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 12:23:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.REINV.INP.CAP.COVER
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEEVA T
* PROGRAM NAME: REDO.APAP.REINV.INP.CAP.COVER
* ODR NO      : ODR-2009-10-0346
*----------------------------------------------------------------------
*DESCRIPTION: REDO.APAP.REINV.INP.CAP.COVER is an input routine for
*             the versions REDO.H.AZ.REINV.DEPOSIT,CPH which checks
*             if there is inadequate capital cover




*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH:  REDO.H.AZ.REINV.DEPOSIT,CPH
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*13.08.2010   JEEVA T        ODR-2009-10-0346  INITIAL CREATION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*18-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM,++ to +=
*18-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION CALL RTN FORMAT MODIFIED
*----------------------------------------------------------------------------------------

*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_F.REDO.APAP.MORTGAGES.DETAIL
    $INSERT I_F.REDO.APAP.CPH.PARAMETER
    $INSERT I_F.REDO.H.AZ.REINV.DEPOSIT



    GOSUB MAIN.PARA
RETURN


**********
MAIN.PARA:
**********
    Y.SUM.OUTS=''
    GOSUB OPEN.PARA

    GOSUB PROCESS.PARA
RETURN

*----------------------------------------------------------------------
OPEN.PARA:
*----------------------------------------------------------------------
    FN.REDO.APAP.CPH.PARAMETER='F.REDO.APAP.CPH.PARAMETER'
    F.REDO.APAP.CPH.PARAMETER=''
    CALL OPF(FN.REDO.APAP.CPH.PARAMETER,F.REDO.APAP.CPH.PARAMETER)

    FN.REDO.APAP.MORTGAGES.DETAIL='F.REDO.APAP.MORTGAGES.DETAIL'
    F.REDO.APAP.MORTGAGES.DETAIL=''
    CALL OPF(FN.REDO.APAP.MORTGAGES.DETAIL,F.REDO.APAP.MORTGAGES.DETAIL)

RETURN

*----------------------------------------------------------------------
PROCESS.PARA:
*----------------------------------------------------------------------

    Y.MG.ACT.NOS=R.NEW(REDO.AZ.REINV.MG.ACT.NO)
    Y.MAT.DATE=R.NEW(REDO.AZ.REINV.END.DATE)
    IF NOT(Y.MG.ACT.NOS) THEN
        RETURN
    END
    AF = REDO.AZ.REINV.MG.ACT.NO
    CALL DUP

    Y.ACT.COUNT=DCOUNT(Y.MG.ACT.NOS,@VM)
    Y.COUNT=1
    LOOP
    WHILE Y.COUNT LE Y.ACT.COUNT
        Y.MSG.DET.ID= Y.MG.ACT.NOS<1,Y.COUNT>
        GOSUB MORT.DETAIL
        Y.OUT.AMT=''
        CALL APAP.REDOAPAP.REDO.APAP.GET.OUTSTANDING.AMT(Y.MAT.DATE,ARR.ID,Y.OUT.AMT) ;*R22 MANUAL CODE CONVERSION
        Y.SUM.OUTS+=Y.OUT.AMT
        Y.COUNT += 1
    REPEAT
    APP.ID=R.NEW(REDO.AZ.REINV.DEPOSIT.PRODUCT)
    CALL CACHE.READ('F.AZ.PRODUCT.PARAMETER',APP.ID,R.APP,ARR.ERR)
    LOAN.DEPOSIT=R.APP<AZ.APP.LOAN.DEPOSIT>
    CURRENCY=R.NEW(REDO.AZ.REINV.CURRENCY)
    PI.KEY=R.APP<AZ.APP.PERIODIC.RATE.KEY>
    PI.METHOD = R.APP<AZ.APP.PI.METHOD>
    BI.KEY = R.APP<AZ.APP.RATE.KEY>
    BI.SPREAD = R.APP<AZ.APP.RATE.SPREAD>
    BI.OPERAND = R.APP<AZ.APP.RATE.OPERAND>
    BI.PERCENT = R.APP<AZ.APP.RATE.PERCENT>
    FIXED.RATE = R.APP<AZ.APP.INT.FIXED.RATE>
    U.MULTI  =   R.APP<AZ.APP.MULTI>
    RATE.PERIOD =R.APP<AZ.APP.RATE.PERIOD>
    INT.BASIS=R.APP<AZ.APP.INT.BASIS>[1,1]
    START.DATE=R.NEW(REDO.AZ.REINV.START.DATE)
    END.DATE=R.NEW(REDO.AZ.REINV.END.DATE)
    AMOUNT=R.NEW(REDO.AZ.REINV.DEPOSIT.AMOUNT)
    REGION=''
    LAST.DAY.INCLUSIVE=R.APP<AZ.APP.LAST.DAY.INCL>

    CALL EB.CALC.INTEREST.RATE(LOAN.DEPOSIT,AMOUNT,CURRENCY,PI.KEY,PI.METHOD,BI.KEY,BI.SPREAD,BI.OPERAND,BI.PERCENT,FIXED.RATE,START.DATE,END.DATE,AZ.INT.RATE)
    CALL AZ.INTEREST.CALC(START.DATE,END.DATE,AZ.INT.RATE,AMOUNT,INT.BASIS,REGION,CURRENCY,LAST.DAY.INCLUSIVE,INTEREST.AMOUNT,INT.AMTS,RESERVED.3,RESERVED.2,RESERVED.1)
    Y.MAT.AMT=AMOUNT+INTEREST.AMOUNT

    GOSUB VAL.EXCESS.PERC

RETURN
*----------------------------------------------------------------------
VAL.EXCESS.PERC:
*----------------------------------------------------------------------
    GOSUB READ.CPH.PARAMETER
    Y.DIFF.PERC=(Y.SUM.OUTS-Y.MAT.AMT)*100/Y.MAT.AMT
    IF Y.DIFF.PERC LT Y.EXCESS.PERC THEN
        ETEXT='EB-REDO.DEP.NOT.COVERED'
        CALL STORE.END.ERROR
    END
RETURN
*----------------------------------------------------------------------
READ.CPH.PARAMETER:
*----------------------------------------------------------------------
    Y.PARA.ID='SYSTEM'
    CALL CACHE.READ(FN.REDO.APAP.CPH.PARAMETER,Y.PARA.ID,R.REDO.APAP.CPH.PARAMETER,PARA.ERR)
    Y.EXCESS.PERC=R.REDO.APAP.CPH.PARAMETER<CPH.PARAM.EXCESS.PERCENTAGE>
RETURN
*----------------------------------------------------------------------
MORT.DETAIL:
*----------------------------------------------------------------------
    CALL F.READ(FN.REDO.APAP.MORTGAGES.DETAIL,Y.MSG.DET.ID,R.REDO.APAP.MORTGAGES.DETAIL,F.REDO.APAP.MORTGAGES.DETAIL,MRTG.ERR)
    ARR.ID=R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.ARR.ID>
RETURN
END
