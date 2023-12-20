* @ValidationCode : MjotODUyNjIxMDIzOkNwMTI1MjoxNzAyMzg0MjY1ODExOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Dec 2023 18:01:05
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
$PACKAGE APAP.TAM
SUBROUTINE PACS.FT.DELETE
*-------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*24-04-2023       Samaran T               R22 Manual Code Conversion       INP.ID  TO FT.ID
*08-12-2023     SURESH             R22 MANUAL CODE CONVERISON  OPF TO OPEN
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $USING EB.TransactionControl
    $USING ST.CompanyCreation

    FN.FT = 'F.FUNDS.TRANSFER$NAU'
    F.FT = ''
    CALL OPF(FN.FT, F.FT)

    FN.SL = "&SAVEDLISTS&"
    F.SL = ""
*CALL OPF(FN.SL, F.SL)
    OPEN FN.SL TO F.SL ELSE
    END ;*R22 MANUAL CODE CONVERSION

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
            *CALL LOAD.COMPANY(R.FT<FT.CO.CODE>)
            ST.CompanyCreation.LoadCompany(R.FT<FT.CO.CODE>)
            CALL F.DELETE(FN.FT, FT.ID)

            *CALL JOURNAL.UPDATE("")
            EB.TransactionControl.JournalUpdate("")

        END

    REPEAT


RETURN
