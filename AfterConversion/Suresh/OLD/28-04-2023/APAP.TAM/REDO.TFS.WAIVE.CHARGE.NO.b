* @ValidationCode : Mjo0OTI4OTE3MjU6Q3AxMjUyOjE2ODI2NjE4NTM4Mjk6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Apr 2023 11:34:13
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
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.TFS.WAIVE.CHARGE.NO
*----------------------------------------------
*Description: This routine is to defaulte the WAIVE.CHARGE field as NO when it is null.
*----------------------------------------------
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*17/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*17/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.T24.FUND.SERVICES

    GOSUB PROCESS
RETURN
*----------------------------------------------
PROCESS:
*----------------------------------------------
    Y.TRANSACTION = R.NEW(TFS.TRANSACTION)
    Y.TXN.CNT = DCOUNT(Y.TRANSACTION,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.TXN.CNT

        IF R.NEW(TFS.WAIVE.CHARGE)<1,Y.VAR1> EQ '' THEN
            R.NEW(TFS.WAIVE.CHARGE)<1,Y.VAR1> = 'NO'
        END
        Y.VAR1++
    REPEAT

    IF AF EQ TFS.DO.CASH.BACK THEN
        IF COMI EQ 'YES' THEN
            GOSUB SET.NET.ENTRY     ;* If DO CASHBACK is set to YES then we need to set Net entry as Credit.
        END
    END

RETURN
*----------------------------------------------
SET.NET.ENTRY:
*----------------------------------------------
* If DO CASHBACK is set as YES, then Netting needs to be done. cos we will have more than one transaction in TFS.

    R.NEW(TFS.NET.ENTRY) = 'CREDIT'

RETURN
END
