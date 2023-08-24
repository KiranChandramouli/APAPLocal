* @ValidationCode : MjoxMzc4MDk3OTE5OkNwMTI1MjoxNjkwMTY3NTUzMTI5OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:13
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
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.V.ASAMBLEA.CED
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       No changes
* 13-07-2023     Harishvikram C   Manual R22 conversion       BP Removed
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.CUSTOMER
    $INSERT  I_F.ACCOUNT
    $INSERT  I_F.ST.L.APAP.ASAMBLEA.VOTANTE
    $INSERT  I_F.ST.L.APAP.ASAMBLEA.PARTIC
    $INSERT  I_F.ST.L.APAP.ASAMBLEA.PARAM

    Y.CEDULA = COMI

    FN.CUS = "FBNK.CUSTOMER"
    FV.CUS = ""

    CALL OPF(FN.CUS,FV.CUS)

    IF V$FUNCTION EQ 'I' THEN

        IF R.OLD(1) EQ '' THEN
            SEL.CMD = "SELECT " : FN.CUS : " WITH L.CU.CIDENT EQ " : Y.CEDULA : " SAMPLE 1"
            CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,SEL.ERR)
            LOOP REMOVE CUSTOMER.ID FROM SEL.LIST SETTING STMT.POS

            WHILE CUSTOMER.ID DO
                GOSUB READ.CUSTOMER
            REPEAT

            IF R.CUS EQ '' THEN
                E = "CEDULA INVALIDA, FAVOR VERIFICAR."
                CALL ERR
                MESSAGE = 'REPEAT'
                V$ERROR = 1
                RETURN
            END

        END
    END

RETURN

READ.CUSTOMER:
    CALL F.READ(FN.CUS, CUSTOMER.ID, R.CUS, FV.CUS, CUS.ERR)
RETURN

END
