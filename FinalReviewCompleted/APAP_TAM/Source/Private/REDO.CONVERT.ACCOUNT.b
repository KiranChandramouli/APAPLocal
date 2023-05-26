* @ValidationCode : MjotMTM0NjAzNTc1ODpDcDEyNTI6MTY4NDg0MjA5MjExNjpJVFNTOi0xOi0xOjM4NjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 386
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CONVERT.ACCOUNT(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT)
*Description
*-------------
*This routine is to return the ACCOUNT NUMBER or the ARRANGEMENT.ID ,
*when the input is ACCOUNT number it willl return the ARRANGEMENT ID
*and it is vice versa for the ARRANGEMENT.ID
*

*IN.ACC.ID -value will be optional or an valid ACCOUNT of the arrangement
*IN.ARR.ID -value will be optional or an valid ARRANGEMENT.ID
*OUT.ID - output will be ACCOUNT Number or ARRANGEMENT.ID

* ------------------------------------------------------------------------
*
* The routine caters to the following tasks :-
* ---------------------------------------------

* Input / Output
* --------------

* IN : ACCOUNT NUMBER OR ARRANGEMENT ID
* OUT : ACCOUNT NUMBER OR ARRANGEMENT ID

* Dependencies
* ------------
* CALLS:
*
* CALLED BY : -NA-

*-----------------------------------------------------------------------

* Revision History
* ----------------
* Date Who Reference Description
*2-JUN-10 H GANESH ODR-2009-10-0324 Intial Version
*-----------------------------------------------------------------------------------
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ALTERNATE.ACCOUNT
    $INSERT I_F.ACCOUNT

    GOSUB INIT
    GOSUB PROCESS

RETURN
INIT:
****
    OUT.ARR.ID=""
    Y.ACCOUNT.NUMBER=""
    OUT.ID=""
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT'
    F.ALTERNATE.ACCOUNT = ''
    CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)

RETURN
*************************************************************************************
PROCESS:
**********

    IF IN.ACC.ID NE "" THEN
        CALL F.READ(FN.ACCOUNT,IN.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
        IF R.ACCOUNT THEN
            OUT.ARR.ID =R.ACCOUNT<AC.ARRANGEMENT.ID>
        END
        OUT.ID =OUT.ARR.ID
    END

    IF IN.ARR.ID NE "" THEN
        CALL F.READ(FN.ALTERNATE.ACCOUNT,IN.ARR.ID,R.ALTERNATE.ACCOUNT, F.ALTERNATE.ACCOUNT, ERR.ALTERNATE.ACCOUNT)
        IF R.ALTERNATE.ACCOUNT THEN
            Y.ACCOUNT.NUMBER = R.ALTERNATE.ACCOUNT<AAC.GLOBUS.ACCT.NUMBER>
        END
        OUT.ID=Y.ACCOUNT.NUMBER
    END

    IF OUT.ID EQ "" THEN
        ERR.TEXT="ERROR IN THE GIVEN ACCOUNT NUMBER"
    END


RETURN

*************************************************************************************
END
