* @ValidationCode : Mjo5NzMzNjczMjc6Q3AxMjUyOjE2ODE3MzM5NzgzMjM6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 17:49:38
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
SUBROUTINE REDO.V.VAL.STATUS.NOINPUT
*---------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*17-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*17-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SHANKAR RAJU
*Program   Name    :REDO.V.VAL.STATUS.NOINPUT
*Reference Number  :HD1048505
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is to make the STATUS field NOINPUT

*LINKED WITH       :
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.ID

    IF COMI NE '' THEN
        T(TT.TID.STATUS)<3>='NOINPUT'
        IF R.NEW(TT.TID.USER) NE '' THEN
            T(TT.TID.USER)<3>='NOINPUT'
        END
    END

RETURN
END
