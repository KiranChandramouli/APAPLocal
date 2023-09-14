* @ValidationCode : Mjo0NDQ3NDUyOTg6Q3AxMjUyOjE2ODA3NzMyMzA0NTc6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 14:57:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.ACH.CHK.OV.CLA
*-------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*06-04-2023       Conversion Tool        R22 Auto Code conversion          SM TO @SM
*06-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------

    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_COMMON
    $INSERT I_EQUATE


    Y.OVER=R.NEW(FT.OVERRIDE)
    Y.CHK.CL=DCOUNT(Y.OVER,@SM)
    IF Y.CHK.CL GT 1 THEN
        ETEXT='EB-CLASS.OVERRIDE'
        CALL STORE.END.ERROR
    END
RETURN
END
