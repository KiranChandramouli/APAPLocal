* @ValidationCode : MjotNDUwOTk2ODkzOkNwMTI1MjoxNjgxODI5MDgxODcwOklUU1M6LTE6LTE6LTI6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 20:14:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -2
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Version 1 13/04/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*12-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*12-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------
SUBROUTINE REDO.COL.DELIVERY.SELECT
*-----------------------------------------------------------------------------
* REDO DELIVERY INTERFACE
* Create the list of the tables to be proceesed on this interface
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.COL.DELIVERY.COMMON
*-----------------------------------------------------------------------------

    LIST.PARAMETERS = '' ; ID.LIST = ''

* This list contains the name of the tables to process
* We take one by one, because we need to guarantee the ACID for eact table
    E = ''
    CALL  REDO.COL.R.DEL.UPD.LOCKING("READ", ID.LIST)
    IF E NE '' THEN
        CALL OCOMO("OMITTING THE COLLECTOR.DELIVERY PROCESS")
        CALL OCOMO(E)
        ID.LIST = ""
    END

    CALL BATCH.BUILD.LIST(LIST.PARAMETERS,ID.LIST)

RETURN
END
