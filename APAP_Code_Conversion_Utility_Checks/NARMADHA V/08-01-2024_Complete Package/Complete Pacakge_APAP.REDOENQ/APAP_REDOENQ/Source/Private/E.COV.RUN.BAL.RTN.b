* @ValidationCode : MjotMjQ0MDA5NDYzOlVURi04OjE3MDQ3MTU5NDg1MjU6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Jan 2024 17:42:28
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE E.COV.RUN.BAL.RTN
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF
*--------------------------------------------------------------------------------------------------------
*Description  : E.COV.RUN.BAL.RTN  is a conversion routine
*               This routine is used to calculate running balance of a account
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                              Reference               Description
* -----------    ------------------------           ----------------        ----------------
* 30 DEC 2010      PRASHANTH RAI                    ODR-2010-08-0181        Initial Creation
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - Added +=
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    Y.COUNT =DCOUNT(O.DATA,'*')
    IF Y.COUNT EQ 3 THEN
        Y.VAL1=TRIM(FIELD(O.DATA,'*',1,1))
        Y.VAL2=""
        Y.VAL3=TRIM(FIELD(O.DATA,'*',2,1))
        Y.VAL4=TRIM(FIELD(O.DATA,'*',3,1))
    END ELSE
        IF Y.COUNT EQ 5 THEN
            Y.VAL1 = TRIM(FIELD(O.DATA,'*',2,1))
            Y.VAL2 = TRIM(FIELD(O.DATA,'*',3,1))
            Y.VAL3 = TRIM(FIELD(O.DATA,'*',4,1))
            Y.VAL4 = TRIM(FIELD(O.DATA,'*',5,1))
        END ELSE
            Y.VAL1=TRIM(FIELD(O.DATA,'*',1,1))
            Y.VAL2=TRIM(FIELD(O.DATA,'*',2,1))
            Y.VAL3=TRIM(FIELD(O.DATA,'*',3,1))
            Y.VAL4=TRIM(FIELD(O.DATA,'*',4,1))
        END
    END
    IF Y.VAL2 NE Y.VAL4 THEN
        Y.VAL1=Y.VAL3
        Y.VAL2=Y.VAL4
    END ELSE
        Y.VAL1 += Y.VAL3   ;*R22 Auto Conversion  - Added +=
    END
    O.DATA = TRIM(Y.VAL1) : '*' : TRIM(Y.VAL2)
RETURN
*--------------------------------------------------------------------------------------------------------
END
