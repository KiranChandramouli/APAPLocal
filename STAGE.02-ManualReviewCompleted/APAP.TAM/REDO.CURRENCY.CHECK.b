* @ValidationCode : MjotMTkxOTQyMTA4NTpDcDEyNTI6MTY4MDc3MzQ5MTE4MjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:01:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CURRENCY.CHECK
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is an INPUT routine attached to below versions,
*

* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
*
* 10-11-2010        JEEVA T           N.45                INITIAL CREATION
* 25-04-2011        Bharath G         PACS00055023        Read ALTERNATE.ACCOUNT instead of account
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*------------------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
*   $INSERT I_F.ACCOUNT
    $INSERT I_F.ALTERNATE.ACCOUNT

    GOSUB INIT
RETURN

INIT:

    FN.ACCOUNT ='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

* PACS00055023 - S
    FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT'
    F.ALTERNATE.ACCOUNT  = ''
    R.ALTERNATE.ACCOUNT = ''
    CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)

    Y.AA.ARR = R.NEW(FT.DEBIT.ACCT.NO)
    CALL F.READ(FN.ALTERNATE.ACCOUNT,Y.AA.ARR,R.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT,Y.ALT.ACC.ERR)
    IF R.ALTERNATE.ACCOUNT THEN
        Y.ARR = R.ALTERNATE.ACCOUNT<AAC.GLOBUS.ACCT.NUMBER>
    END
    ELSE
        Y.ARR = R.NEW(FT.DEBIT.ACCT.NO)
    END
* PACS00055023 - E

    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
*  Y.ARR = R.NEW(FT.DEBIT.ACCT.NO)
        CALL F.READ(FN.ACCOUNT,Y.ARR,R.ACCOUNT,F.ACCOUNT,Y.ERR)
        Y.CURR = R.ACCOUNT<AC.CURRENCY>
        R.NEW(FT.DEBIT.CURRENCY) = Y.CURR
    END
RETURN

END
