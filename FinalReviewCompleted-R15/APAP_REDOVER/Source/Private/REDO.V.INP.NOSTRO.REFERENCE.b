* @ValidationCode : MjotMzI5MzYyMzI0OkNwMTI1MjoxNjg0ODQ1NjIwNTQwOklUU1M6LTE6LTE6MTc2OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 18:10:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 176
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.NOSTRO.REFERENCE

*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep S
* Program Name  : REDO.V.INP.NOSTRO.REFERENCE
*-------------------------------------------------------------------------
* Description: This routine is input routine to default THEIR.REFERENCE for TELLER
*              and DEBIT.THIER.REFERENCE/CREDIT.THEIR.REFERENCE for FUNDS.TRANSFER
*-------------------------------------------------------------------------
* Linked with   :
* In parameter  :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*------------------------------------------------------------------------
* DATE         Name          ODR / HD REF              DESCRIPTION
* 14-09-12     Pradeep S     PACS00183693              Initial creation
*------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*12-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*12-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

PROCESS:
*********

    BEGIN CASE

        CASE APPLICATION EQ "FUNDS.TRANSFER"
            IF R.NEW(FT.DEBIT.ACCT.NO) THEN
                Y.ACCT.ID = R.NEW(FT.DEBIT.ACCT.NO)
                GOSUB READ.ACCT
                IF Y.NOSTRO.FLAG THEN
                    R.NEW(FT.DEBIT.THEIR.REF) = R.NEW(FT.CHEQUE.NUMBER)
                    RETURN
                END
            END

            IF R.NEW(FT.CREDIT.ACCT.NO) THEN
                Y.ACCT.ID = R.NEW(FT.CREDIT.ACCT.NO)
                GOSUB READ.ACCT
                IF Y.NOSTRO.FLAG THEN
                    R.NEW(FT.CREDIT.THEIR.REF) = R.NEW(FT.CHEQUE.NUMBER)
                    RETURN
                END
            END

        CASE APPLICATION EQ "TELLER"
            IF R.NEW(TT.TE.ACCOUNT.1) THEN
                Y.ACCT.ID = R.NEW(TT.TE.ACCOUNT.1)
                GOSUB READ.ACCT
            END

            IF R.NEW(TT.TE.ACCOUNT.2) THEN
                Y.ACCT.ID = R.NEW(TT.TE.ACCOUNT.2)
                GOSUB READ.ACCT
            END

            IF Y.NOSTRO.FLAG THEN
                R.NEW(TT.TE.THEIR.REFERENCE) = R.NEW(TT.TE.CHEQUE.NUMBER)
            END
    END CASE

RETURN

READ.ACCT:
***********

    R.ACC = ''
    CALL F.READ(FN.ACCT,Y.ACCT.ID,R.ACC,F.ACCT,ERR.ACC)
    IF R.ACC AND R.ACC<AC.LIMIT.REF> EQ "NOSTRO" THEN
        Y.NOSTRO.FLAG = @TRUE
    END
RETURN


INIT:
******

    Y.NOSTRO.FLAG = @FALSE
    Y.ACCT.ID = ''

RETURN

OPEN.FILES:
************

    FN.ACCT = 'F.ACCOUNT'
    F.ACCT = ''
    CALL OPF(FN.ACCT,F.ACCT)

RETURN

END
