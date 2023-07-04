* @ValidationCode : MjotODY3OTQzODE0OkNwMTI1MjoxNjgyNDEyMzY0MzE2OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:04
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
SUBROUTINE REDO.V.VAL.SAVING.ACCT
*----------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Bharath G
*Program   Name    :REDO.V.VAL.SAVING.ACCT
*----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who                 Reference            Description
* 16-APR-2010          Bharath G           PACS00055029         Initial Creation
* 14-Mar-2018          Gopala Krishnan R   PACS00646692         Code Updation
*----------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*17-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*17-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.FT.TT.TRANSACTION
*----------------------------------------------------------------------------------
    GOSUB INIT
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB PROCESS.FT
    END
    IF APPLICATION EQ 'REDO.FT.TT.TRANSACTION' THEN
        GOSUB PROCESS.REDO.FT.TT
    END
RETURN
*----------------------------------------------------------------------------------
INIT:
*----

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    R.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*----------------------------------------------------------------------------------
PROCESS.FT:
*---------
*
    Y.AC.ID = R.NEW(FT.CREDIT.ACCT.NO)

    CALL F.READ(FN.ACCOUNT,Y.AC.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)

    IF R.ACCOUNT<AC.ARRANGEMENT.ID> NE '' OR R.ACCOUNT<AC.ALL.IN.ONE.PRODUCT> NE '' THEN
        AF = FT.CREDIT.ACCT.NO
        ETEXT = "EB-NOT.SAVING.AC"
        CALL STORE.END.ERROR
    END

RETURN
*----------------------------------------------------------------------------------
PROCESS.REDO.FT.TT:
*---------
*
    Y.AC.ID = R.NEW(FT.TN.CREDIT.ACCT.NO)

    CALL F.READ(FN.ACCOUNT,Y.AC.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)

    IF R.ACCOUNT<AC.ARRANGEMENT.ID> NE '' OR R.ACCOUNT<AC.ALL.IN.ONE.PRODUCT> NE '' THEN
        AF = FT.TN.CREDIT.ACCT.NO
        ETEXT = "EB-NOT.SAVING.AC"
        CALL STORE.END.ERROR
    END

RETURN
END
