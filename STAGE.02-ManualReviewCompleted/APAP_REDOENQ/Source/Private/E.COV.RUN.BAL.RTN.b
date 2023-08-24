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
