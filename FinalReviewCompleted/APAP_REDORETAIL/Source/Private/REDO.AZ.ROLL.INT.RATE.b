* @ValidationCode : MjotODI5MzQzMjU1OkNwMTI1MjoxNjgxMjgzOTQyMzU3OklUU1M6LTE6LTE6MjAwOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:49:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.AZ.ROLL.INT.RATE(GET.RATE)
*-------------------------------------------------------------
*Description: This routine is call routine from deal slip of
*-------------------------------------------------------------
*Input Arg : GET.RATE
*Out Arg   : GET.RATE
*Deals With:
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    CALL F.READ(FN.AZ.ACCOUNT,GET.RATE,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACCOUNT.ERR)
    IF R.AZ.ACCOUNT<AZ.ROLLOVER.INT.RATE> THEN
        GET.INT.RATE.VAL = R.AZ.ACCOUNT<AZ.ROLLOVER.INT.RATE>
    END ELSE
        GET.INT.RATE.VAL = R.AZ.ACCOUNT<AZ.INTEREST.RATE>
    END

    GET.RATE = FMT(GET.INT.RATE.VAL,"16L,2")
RETURN
END
