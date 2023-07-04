* @ValidationCode : MjoxMzg0MTg5Njk0OkNwMTI1MjoxNjgwNjgwNjA3OTIxOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:13:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE  REDO.DEL.PEND.HIS(DEL.REC)
*---------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is to delete the records from REDO.PENDING.CHARGE$HIS file

* Input/Output:
*--------------
* IN :
* OUT :
*
* Dependencies:
*---------------
* CALLS :
* CALLED BY :
*
* Revision History:
*---------------------------------------------------------------------------
*   Date               who           Reference            Description
* 10-JAN-2010     SHANKAR RAJU     ODR-2009-10-0529     Initial Creation
** 06-04-2023 R22 Auto Conversion no changes
** 06-04-2023 Skanda R22 Manual Conversion - No changes
*---------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STMT.ENTRY
    $INSERT I_REDO.DEL.PEND.HIS.COMMON
*---------------------------------------------------------------------------
    GOSUB DEL.PENDING.CHARGE
RETURN
*---------------------------------------------------------------------------
DEL.PENDING.CHARGE:
*~~~~~~~~~~~~~~~~~~
    CALL F.DELETE(FN.PEND.CHG.HIS,DEL.REC)
RETURN
*---------------------------------------------------------------------------
END
