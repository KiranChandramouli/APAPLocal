* @ValidationCode : MjotMjAxMjY0MjU5MDpDcDEyNTI6MTY4MjUyODQ2MzczOTpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Apr 2023 22:31:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE  REDO.LY.V.INTC
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the internal account in Usage Txn.
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.LY.V.INTC
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*11.04.2014    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_GTS.COMMON
 
    $INSERT I_F.REDO.LY.POINTS.US

    Y.INT.ACCT = COMI

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*----------
OPEN.FILES:
*----------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN

*-------
PROCESS:
*-------

    Y.US.MOV = R.NEW(REDO.PT.US.MOV.US)

    IF Y.INT.ACCT EQ '' AND Y.US.MOV EQ 'Interno' THEN
        AF = REDO.PT.US.INT.ACCT.MOV.US
        ETEXT = 'EB-REDO.LY.V.SAVC2'
        CALL STORE.END.ERROR
        RETURN
    END

    R.ACCOUNT = '' ; ACC.ERR = ''
    CALL F.READ(FN.ACCOUNT,Y.INT.ACCT,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT THEN
        GOSUB CHECK.INT.ACCT
    END ELSE
        IF Y.US.MOV EQ 'Interno' THEN
            GOSUB GET.ERROR
        END
    END

RETURN

*---------------
CHECK.INT.ACCT:
*---------------

    Y.ACCT.CAT = R.ACCOUNT<AC.CATEGORY>

    IF Y.ACCT.CAT GE '10000' AND Y.ACCT.CAT LE '69999' ELSE
        GOSUB GET.ERROR
    END

RETURN

*---------
GET.ERROR:
*---------

    AF = REDO.PT.US.INT.ACCT.MOV.US
    ETEXT = 'EB-REDO.LY.V.SAVC'
    CALL STORE.END.ERROR

RETURN

*----------------------------------------------------------------------------------
END
