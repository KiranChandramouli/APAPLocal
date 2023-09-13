* @ValidationCode : Mjo3MTM0NjgxNzpDcDEyNTI6MTY4MjQxMjM0NDA1NTpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
*Modification history
*Date                Who               Reference                  Description
*13-04-2023      conversion tool     R22 Auto code conversion     No changes
*13-04-2023      Mohanraj R          R22 Manual code conversion   No changes
SUBROUTINE REDO.V.CARD.CONVERSION

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LATAM.CARD.ORDER

    FN.LCO='F.LATAM.CARD.ORDER'
    F.LCO=''
    CALL OPF(FN.LCO,F.LCO)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    SEL.CMD = 'SELECT ':FN.LCO
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,PGM.ERR)

    LOOP
        REMOVE SEL.LIST.ID FROM SEL.LIST SETTING COMP.POS
    WHILE SEL.LIST.ID:COMP.POS

        CALL F.READ(FN.LCO,SEL.LIST.ID,R.LCO,F.LCO,LCO.ERR)
        GET.NINE.NINE = R.LCO<99>
        GET.HUNDRED = R.LCO<100>

        CALL F.READ(FN.CUSTOMER,GET.NINE.NINE,R.CUSTOMER,F.CUSTOMER,CUS.ERR)

        IF R.CUSTOMER THEN
            R.LCO<98> =  R.LCO<99>
        END

        IF R.LCO<100> THEN
            R.LCO<99> = R.LCO<100>
            R.LCO<100> = ''
        END

        CALL F.WRITE(FN.LCO,SEL.LIST.ID,R.LCO)
        CALL JOURNAL.UPDATE("")

    REPEAT


RETURN
