* @ValidationCode : MjotNjIyNjcwNjI1OkNwMTI1MjoxNjgwNjA3MTMyNDA0OklUU1M6LTE6LTE6MTkzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2023 16:48:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 193
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.FT.PROCESS.LOAD
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 05-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 05-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_REDO.FI.FT.PROCESS.COMMON


    GOSUB INIT
RETURN
*----
INIT:
*----

    FN.REDO.TEMP.FI.CONTROL='F.REDO.TEMP.FI.CONTROL'
    F.REDO.TEMP.FI.CONTROL =''
    CALL OPF(FN.REDO.TEMP.FI.CONTROL,F.REDO.TEMP.FI.CONTROL)

    FN.REDO.INTERFACE.PARAM='F.REDO.INTERFACE.PARAM'
    F.REDO.INTERFACE.PARAM =''
    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)
RETURN
END
