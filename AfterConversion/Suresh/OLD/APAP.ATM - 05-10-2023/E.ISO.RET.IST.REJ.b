$PACKAGE APAP.ATM
* @ValidationCode : Mjo4MTg1NjA4MzU6Q3AxMjUyOjE2OTYzMzY5MTA0MjA6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 03 Oct 2023 18:11:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.


SUBROUTINE E.ISO.RET.IST.REJ(Y.ID.LIST)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes
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
*CALL REDO.UPD.ATM.REJ
        APAP.LAPAP.redoUpdAtmRej() ;*R22 MANUAL CONVERSION
    END

RETURN
END
