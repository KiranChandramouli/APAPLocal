* @ValidationCode : MjotNTg4MzE2MjU2OkNwMTI1MjoxNjg0ODUxOTYwODA4OklUU1M6LTE6LTE6LTE6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 19:56:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -1
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE E.ISO.RET.IST.REJ(Y.ID.LIST)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - Call routine modified
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.SPF
    $INSERT I_AT.ISO.COMMON
    $USING APAP.LAPAP



    Y.ID.LIST = "STATUS:1:1=":R.SPF.SYSTEM<SPF.OP.MODE>
    Y.ID.LIST:=',UNIQUE.TXN.CODE:1:1=1'
    Y.ID.LIST := ',Y.ISO.RESPONSE:1:1=00'
    AT$AT.ISO.RESP.CODE=AT$INCOMING.ISO.REQ(39)

    IF AT$AT.ISO.RESP.CODE NE '00' THEN
        APAP.LAPAP.redoUpdAtmRej() ;*R22 Manual Conversion
    END

RETURN
END
