* @ValidationCode : MjotMTk4MzY1Mjk4ODpDcDEyNTI6MTY4MjQxMjM2MTk1MjpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.INPUTTED.AMT
*---------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.V.VAL.INPUTTED.AMT
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*DESCRIPTION: This routine is validation routine attached to CHEQUE.NO field in
* TELLER,PAY.CHQ
* TELLER,PAY.EXPIRE.CHQ
*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*19.02.2010  H GANESH     ODR-2009-12-0285  INITIAL CREATION
*----------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*17-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*17-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.ADMIN.CHQ.DETAILS

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

    FN.REDO.ADMIN.CHQ.DETAILS='F.REDO.ADMIN.CHQ.DETAILS'
    F.REDO.ADMIN.CHQ.DETAILS=''

RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------

    CALL OPF(FN.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS)

RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    Y.CHEQUE.NO=COMI
*    Y.CHEQUE.NO=R.NEW(TT.TE.CHEQUE.NUMBER)
    CALL F.READ(FN.REDO.ADMIN.CHQ.DETAILS,Y.CHEQUE.NO,R.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS,ADMIN.CHQ.ERR)
    Y.AMOUNT=R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.AMOUNT>
    Y.BENEFICIARY=R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.BENEFICIARY>
    Y.TELLER.AMOUNT=R.NEW(TT.TE.AMOUNT.LOCAL.1)
    Y.STATUS=R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.STATUS>
    R.NEW(TT.TE.NARRATIVE.1) = Y.BENEFICIARY

    IF (Y.AMOUNT EQ '') OR (Y.AMOUNT NE Y.TELLER.AMOUNT) THEN

        AV = TT.TE.AMOUNT.LOCAL.1
        ETEXT = 'EB-AMOUNT.NOT.MATCH'
        CALL STORE.END.ERROR

    END

    IF PGM.VERSION EQ ',PAY.CHQ' THEN

        IF Y.STATUS NE 'ISSUED' THEN

            AF = TT.TE.CHEQUE.NUMBER
            ETEXT = 'EB-STATUS.NOT.ISSUE'
            CALL STORE.END.ERROR

        END

    END

    IF PGM.VERSION EQ ',PAY.EXPIRE.CHQ' THEN

        IF Y.STATUS NE 'RECLASSIFY' THEN

            AF = TT.TE.CHEQUE.NUMBER
            ETEXT='EB-STATUS.NOT.RECLASSIFY'
            CALL STORE.END.ERROR

        END

    END

RETURN

END
