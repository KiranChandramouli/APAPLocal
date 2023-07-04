* @ValidationCode : MjotNTYxMTc4NjQ2OkNwMTI1MjoxNjgzODkyNjIwODk4OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 May 2023 17:27:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.ACCOUNT.INT.RATE
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to get the Account Int Rate
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Ganesh R
* PROGRAM NAME : REDO.GET.ACCOUNT.INT.RATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 02-08-2012   GANESH R              ODR-2010-03-0141   INITIAL CREATION
*-----------------------------------------------------------------------------------
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION            F.READ TO CACHE.READ, F.GROUP.DATE TO R.GROUP.DATE,
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT.CREDIT.INT
    $INSERT I_F.GROUP.CREDIT.INT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.GROUP.DATE

    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS
RETURN

INIT:
    Y.ACCT.ID = O.DATA
    O.DATA = ''

RETURN

OPENFILE:

    FN.ACCOUNT.CREDIT.INT = 'F.ACCOUNT.CREDIT.INT'
    F.ACCOUNT.CREDIT.INT  = ''
    CALL OPF(FN.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT)

    FN.GROUP.CREDIT.INT = 'F.GROUP.CREDIT.INT'
    F.GROUP.CREDIT.INT  = ''
    CALL OPF(FN.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.GROUP.DATE = 'F.GROUP.DATE'
    F.GROUP.DATE  = ''
    CALL OPF(FN.GROUP.DATE,F.GROUP.DATE)

RETURN

PROCESS:

    CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    Y.CCY      = R.ACCOUNT<AC.CURRENCY>
    Y.AC.GROUP = R.ACCOUNT<AC.CONDITION.GROUP>

    Y.ACI.DATE = R.ACCOUNT<AC.ACCT.CREDIT.INT,1>
    Y.ACI.ID = Y.ACCT.ID:'-':Y.ACI.DATE
    CALL F.READ(FN.ACCOUNT.CREDIT.INT,Y.ACI.ID,R.ACI,F.ACCOUNT.CREDIT.INT,ERR.ACI)
    IF R.ACI THEN
        O.DATA = R.ACI<IC.ACI.CR.BASIC.RATE,1>
        IF NOT(O.DATA) THEN
            O.DATA = R.ACI<IC.ACI.CR.INT.RATE,1>
        END
    END ELSE
        Y.GP.DATE.ID = Y.AC.GROUP:Y.CCY
        CALL CACHE.READ(FN.GROUP.DATE, Y.GP.DATE.ID, R.GROUP.DATE, GROUP.ERR) ;*AUTO R22 CODE CONVERSION
        IF R.GROUP.DATE THEN
            Y.GP.DATE = R.GROUP.DATE<AC.GRD.CREDIT.GROUP.DATE>
        END
        Y.GCI.ID = Y.GP.DATE.ID:Y.GP.DATE
        CALL CACHE.READ(FN.GROUP.CREDIT.INT, Y.GCI.ID, R.GCI, GCI.ERR) ;*AUTO R22 CODE CONVERSION
        O.DATA = R.GCI<IC.GCI.CR.BASIC.RATE,1>
        IF NOT(O.DATA) THEN
            O.DATA = R.GCI<IC.GCI.CR.INT.RATE,1>
        END
    END

RETURN
END
