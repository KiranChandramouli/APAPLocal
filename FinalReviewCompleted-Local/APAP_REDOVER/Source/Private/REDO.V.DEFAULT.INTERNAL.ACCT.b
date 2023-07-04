* @ValidationCode : Mjo3NzU5OTQ5Mjg6Q3AxMjUyOjE2ODI2OTE1MDc2NjY6SVRTUzotMTotMToyNjU6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 28 Apr 2023 19:48:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 265
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.DEFAULT.INTERNAL.ACCT
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is to default internal account FT versions
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY :
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 04-08-2011         Bharath G        PACS00093733        Parameter Table Changed to handle multi-branch internal Acct
* 02-SEP-2011        Marimuthu S      PACS00112734
* 15-SEP-2011        Marimuthu S      PACS00128527
* 13-JUL-2012        MARIMUTHU S      PACS00203617
*------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*11-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*11-04-2023       Samaran T               R22 Manual Code Conversion       CALL routine format modified
*--------------------------------------------------------------------------------------------
 
 

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.BRANCH.INT.ACCT.PARAM
    $USING APAP.TAM

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*----*
INIT:
*----*
*-----------*
*Initialising
*-----------*


    REC.ID='SYSTEM'

    Y.CMPNY.ID = COMI

RETURN

*---------*
OPEN.FILES:
*---------*
*------------*
*Opening files
*------------*

    FN.REDO.BRANCH.INT.ACCT.PARAM ='F.REDO.BRANCH.INT.ACCT.PARAM'
    F.REDO.BRANCH.INT.ACCT.PARAM = ''
    CALL OPF(FN.REDO.BRANCH.INT.ACCT.PARAM,F.REDO.BRANCH.INT.ACCT.PARAM)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN

*-------*
PROCESS:
*-------*
*-----------------------------------------------------*
*Raising Error Message if it is not an arrangement ID
*-----------------------------------------------------*
*

    Y.ARR.ID = R.NEW(FT.DEBIT.ACCT.NO)

    IF Y.ARR.ID[1,2] EQ 'AA' THEN
        IN.ACC.ID = Y.ARR.ID
        IN.ARR.ID = ''
        OUT.ID = ''
        ERR.TEXT = ''
        CALL APAP.TAM.redoConvertAccount(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT) ;*R22 Manual Code Conversion
        Y.ARR.ID = OUT.ID
    END

    CALL F.READ(FN.ACCOUNT,Y.ARR.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    IF R.ACCOUNT THEN
*        R.NEW(FT.DEBIT.CURRENCY)  = R.ACCOUNT<AC.CURRENCY>
*        R.NEW(FT.CREDIT.CURRENCY) = R.ACCOUNT<AC.CURRENCY>
*        R.NEW(FT.LOCAL.REF)<1,VAR.L.FT.CUSTOMER.POS> = R.ACCOUNT<AC.CUSTOMER>
    END

    CALL CACHE.READ(FN.REDO.BRANCH.INT.ACCT.PARAM,REC.ID,R.REDO.BRANCH.INT.ACCT.PARAM,Y.ERR)

    Y.CURRENCY.VAL = R.ACCOUNT<AC.CURRENCY>

    R.NEW(FT.CREDIT.ACCT.NO) = ''

    LOCATE Y.CMPNY.ID IN R.REDO.BRANCH.INT.ACCT.PARAM<BR.INT.ACCT.COMPANY,1> SETTING POS THEN
        LOCATE Y.CURRENCY.VAL IN R.REDO.BRANCH.INT.ACCT.PARAM<BR.INT.ACCT.CURRENCY,POS,1> SETTING CURR.POS THEN
            R.NEW(FT.CREDIT.ACCT.NO) = R.REDO.BRANCH.INT.ACCT.PARAM<BR.INT.ACCT.BRANCH.INT.ACCT,POS,CURR.POS>
            R.NEW(FT.CREDIT.CURRENCY) = Y.CURRENCY.VAL
        END
    END

RETURN
END
