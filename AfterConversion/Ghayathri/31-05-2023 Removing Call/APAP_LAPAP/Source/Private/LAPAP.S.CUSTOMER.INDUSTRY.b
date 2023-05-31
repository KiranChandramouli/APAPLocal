* @ValidationCode : MjotMTQ1NTM2NjMzNjpDcDEyNTI6MTY4NDIyMjgxNTM5MTpJVFNTOi0xOi0xOi03OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.S.CUSTOMER.INDUSTRY(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :APAP
*Program   Name    :LAPAP.S.CUSTOMER.SECTOR1
*---------------------------------------------------------------------------------
*DESCRIPTION       : Basa en la logica de la rutina local REDO.S.CUSTOMER.SECTOR
* para obtener la actividad econimica campo L.APAP.INDUSTRY
* ----------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*21-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*21-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON     ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_REDO.DEAL.SLIP.COMMON   ;*R22 AUTO CODE CONVERSION.END
    GOSUB PROCESS
RETURN
*********
PROCESS:
*********
    Y.OUT = VAR.INDUSTRY
RETURN
END
