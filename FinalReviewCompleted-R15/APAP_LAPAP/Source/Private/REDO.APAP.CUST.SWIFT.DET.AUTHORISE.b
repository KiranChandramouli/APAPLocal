* @ValidationCode : MjoxNjgyNDAxMzM6Q3AxMjUyOjE2OTAxNjc1NTY0MzQ6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:16
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
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.APAP.CUST.SWIFT.DET.AUTHORISE
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       $INCLUDE T24.BP to  $INSERT
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
    $INSERT I_F.REDO.APAP.CUST.SWIFT.DET


    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****
    FN.REDO.APAP.CUST.SWIFT.CONCAT = 'F.REDO.APAP.CUST.SWIFT.CONCAT'
    F.REDO.APAP.CUST.SWIFT.CONCAT  = ''
    CALL OPF(FN.REDO.APAP.CUST.SWIFT.CONCAT,F.REDO.APAP.CUST.SWIFT.CONCAT)
RETURN


PROCESS:
********
    YCUST = R.NEW(REDO.CUSW.CUSTOMER.ID)
    IF YCUST NE '' THEN
        ERR.REDO.APAP.CUST.SWIFT.CONCAT = ''; R.REDO.APAP.CUST.SWIFT.CONCAT = ''
        CALL F.READ(FN.REDO.APAP.CUST.SWIFT.CONCAT,YCUST.ID,R.REDO.APAP.CUST.SWIFT.CONCAT,F.REDO.APAP.CUST.SWIFT.CONCAT,ERR.REDO.APAP.CUST.SWIFT.CONCAT)

        LOCATE YCUST IN R.REDO.APAP.CUST.SWIFT.CONCAT SETTING EL.POSN ELSE
            R.REDO.APAP.CUST.SWIFT.CONCAT<-1> = ID.NEW
            CALL F.WRITE(FN.REDO.APAP.CUST.SWIFT.CONCAT,YCUST,R.REDO.APAP.CUST.SWIFT.CONCAT)
        END
    END
RETURN
END
