*-----------------------------------------------------------------------------
* <Rating>99</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE MB.E.SDB.REFUND.VAT
* Routine will calculate the refund amount and the VAT on it
* To be used in ENQUIRY
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*
    REFUND.AMT = 0
    LOOP
        REMOVE REF.AMT FROM O.DATA SETTING REF.POS
    WHILE REF.AMT:REF.POS
        REFUND.AMT = REFUND.AMT + REF.AMT
    REPEAT
    IF REFUND.AMT LT '0' THEN REFUND.AMT = REFUND.AMT * -1
    VAT.AMT = REFUND.AMT * (17.5/100)
    O.DATA = REFUND.AMT:'*':VAT.AMT
    RETURN
END
