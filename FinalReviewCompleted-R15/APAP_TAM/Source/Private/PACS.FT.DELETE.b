* @ValidationCode : Mjo0Mjc0NzYzMDc6Q3AxMjUyOjE2ODQ0OTEwMjcwNDk6SVRTUzotMTotMTo1OTc6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 597
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE PACS.FT.DELETE
*-------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*24-04-2023       Samaran T               R22 Manual Code Conversion       INP.ID  TO FT.ID
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER

    FN.FT = 'F.FUNDS.TRANSFER$NAU'
    F.FT = ''
    CALL OPF(FN.FT, F.FT)

    FN.SL = "&SAVEDLISTS&"
    F.SL = ""
    CALL OPF(FN.SL, F.SL)

    SL.ID = "SL.PROB.FT"

    CALL F.READ(FN.SL, SL.ID, R.SL, F.SL, SL.ERR)

***FT.ID = "FT21077D16H4"

    LOOP
        REMOVE FT.ID FROM R.SL SETTING SL.POS
*WHILE INP.ID : SL.POS
    WHILE FT.ID : SL.POS    ;*R22 MANUAL CODE CONVERSION
        CALL F.READ(FN.FT,FT.ID,R.FT,F.FT,FT.ERR)

        IF R.FT THEN

            SAVE.ID.COMPANY = ID.COMPANY
            CALL LOAD.COMPANY(R.FT<FT.CO.CODE>)
            CALL F.DELETE(FN.FT, FT.ID)

            CALL JOURNAL.UPDATE("")

        END

    REPEAT


RETURN
