* @ValidationCode : MjotMTgwNDYxOTgzMzpDcDEyNTI6MTY4MTIwMjM2NTAxMTpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 14:09:25
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
SUBROUTINE TAM.V.DEF.TT.ACC
    
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - F TO CACHE
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------
    

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.ID

    $INSERT I_F.COMPANY
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.PARAMETER
    $INSERT I_F.TELLER.TRANSACTION

    GOSUB INIT
    GOSUB PROCESS

RETURN

INIT:

    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION  = ''
    CALL OPF(FN.TELLER.TRANSACTION, F.TELLER.TRANSACTION)

    FN.TELLER.USER = 'F.TELLER.USER'
    F.TELLER.USER = ''
    CALL OPF(FN.TELLER.USER,F.TELLER.USER)

    FN.TELLER.ID = 'F.TELLER.ID'
    F.TELLER.ID = ''
    CALL OPF(FN.TELLER.ID,F.TELLER.ID)
RETURN

PROCESS:
    IF R.NEW(TT.TE.RECORD.STATUS) NE 'INAU' THEN
        ID.TRANSACTION = R.NEW(TT.TE.TRANSACTION.CODE)
        CALL CACHE.READ(FN.TELLER.TRANSACTION, ID.TRANSACTION, R.TELLER.TRANSACTION, TP.ERR)         ;** R22 Auto conversion - F TO CACHE
        WCAT1         = R.TELLER.TRANSACTION<TT.TR.CAT.DEPT.CODE.1>
        Y.COMP.CODE   = R.COMPANY(EB.COM.SUB.DIVISION.CODE)

        Y.USER = OPERATOR

        CALL F.READ(FN.TELLER.USER,Y.USER,R.TELLER.USER,F.TELLER.USER,F.ERR)
        IF R.TELLER.USER EQ '' THEN
            E = 'TT-TID.TILL.NOT.EXIST.CURRENT.USER'
        END ELSE
            CALL F.READ(FN.TELLER.ID,R.TELLER.USER<1>,R.TELLER.ID,F.TELLER.ID,TELLER.ID.ERR)
            IF R.TELLER.ID<TT.TID.STATUS> NE 'OPEN' THEN
                E = 'TT-TILL.NOT.OPEN'
            END ELSE
                Y.TELLER.ID = R.TELLER.USER<1>
            END
        END

        R.NEW(TT.TE.ACCOUNT.1) = 'DOP':WCAT1:Y.TELLER.ID:Y.COMP.CODE
    END
RETURN

END
