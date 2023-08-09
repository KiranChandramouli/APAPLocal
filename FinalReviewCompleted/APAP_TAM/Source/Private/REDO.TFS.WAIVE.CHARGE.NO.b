* @ValidationCode : MjotMTM3NTk1OTc4NTpDcDEyNTI6MTY5MDE3NjEwMTgzNzpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Jul 2023 10:51:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TFS.WAIVE.CHARGE.NO
*----------------------------------------------
*Modification HISTORY:
*Description: This routine is to defaulte the WAIVE.CHARGE field as NO when it is null.
*DATE			           AUTHOR		        Modification                            DESCRIPTION
*13/07/2023	               CONVERSION TOOL      AUTO R22 CODE CONVERSION		VM TO @VM, ++ TO +=1
*13/07/2023	               VIGNESHWARI        	MANUAL R22 CODE CONVERSION		        NOCHANGE
*----------------------------------------------


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
        Y.VAR1 += 1
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
