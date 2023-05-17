* @ValidationCode : MjotMjMzMDM2NzAwOkNwMTI1MjoxNjg0MjIyODE1NDIxOklUU1M6LTE6LTE6LTc6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
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
SUBROUTINE LAPAP.S.CUSTOMER.PJ.NAME(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Melvy Martinez
*Program   Name    :LAPAP.S.CUSTOMER.PJ.NAME
*---------------------------------------------------------------------------------
*DESCRIPTION       : Este programa es utilizado para obtener la razon social de los clientes juridicos
* ----------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*21-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*21-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON   ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_REDO.DEAL.SLIP.COMMON    ;*R22 AUTO CODE CONVERSION.END
    GOSUB PROCESS
RETURN
*********
PROCESS:
*********
    Y.OUT = VAR.SOCIAL[1,30]
RETURN
END
