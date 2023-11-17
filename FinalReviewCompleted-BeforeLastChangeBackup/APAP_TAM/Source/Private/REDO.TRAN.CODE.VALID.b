* @ValidationCode : MjotMTE4Mzk5NjAxMTpDcDEyNTI6MTY4MTEwOTg0MzA4NzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2023 12:27:23
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
SUBROUTINE REDO.TRAN.CODE.VALID
    
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - F TO CACHE
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------
    
*-----------------------------------------------------------------------------
*************************************************************
* 1. Author&Date created  : GOPALA KRISHNAN R (17-NOV-2017)
* 2. Site name            :
* 3. Product              :
* 4. Routine type         :
* 5. Installed            :
* 6. E.V.B record         :
********************************** PROGRAM DESCRIPTION **********************************
* 7. Description
* -------------------
* Get the transaction code from the REDO.MON.MAP.QUEUE, read the corresponding
* TELLER.TRANSACTION record, Locate the customer account side  and get the transaction code.
*****************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.TRANSACTION

    Y.PARAM = COMI
    Y.RETURN = ''

    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION' ; F.TELLER.TRANSACTION = ''
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)
    CALL CACHE.READ(FN.TELLER.TRANSACTION, COMI, CU.REC, TELLER.TRANSACTION.ERR)          ;** R22 Auto conversion - F TO CACHE

    TRAN.CODE1 = '' ; TRAN.CODE1 =CU.REC<TT.TR.TRANSACTION.CODE.1>
    TRAN.CODE2 = '' ; TRAN.CODE2 =CU.REC<TT.TR.TRANSACTION.CODE.2>

    VALID.ACCOUNT1 = ''; VALID.ACCOUNT1 =CU.REC<TT.TR.VALID.ACCOUNTS.1>
    VALID.ACCOUNT2 = ''; VALID.ACCOUNT2 =CU.REC<TT.TR.VALID.ACCOUNTS.2>

    IF VALID.ACCOUNT1 EQ 'CUSTOMER' THEN
        Y.RETURN = TRAN.CODE1
    END ELSE
        IF VALID.ACCOUNT2 EQ 'CUSTOMER' THEN
            Y.RETURN = TRAN.CODE2
        END
    END
    COMI = Y.RETURN

RETURN

END
