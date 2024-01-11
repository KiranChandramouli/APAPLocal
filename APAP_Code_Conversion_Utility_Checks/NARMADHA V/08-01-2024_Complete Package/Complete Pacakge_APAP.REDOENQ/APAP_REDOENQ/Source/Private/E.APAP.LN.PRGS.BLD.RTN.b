* @ValidationCode : MjoxMDQ5MDczMjk3OlVURi04OjE3MDQ3MTUwOTIyMjY6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Jan 2024 17:28:12
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
SUBROUTINE E.APAP.LN.PRGS.BLD.RTN(ENQ.DATA)
*
*
*=====================================================================
* Subroutine Type : BUILD ROUTINE
* Attached to     :
* Attached as     :
* Primary Purpose :
*---------------------------------------------------------------------
* Modification History:
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*------------------------------------------------------------------------

*=====================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.CUSTOMER
*
************************************************************************
*

    Y.ENQ.DATA = ENQ.DATA<4,1>
    CALL System.setVariable("CURRENT.RCA",Y.ENQ.DATA)
    FN.REDO.CREATE.ARRANGEMENT = 'F.REDO.CREATE.ARRANGEMENT'
    F.REDO.CREATE.ARRANGEMENT = ''
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    APPL.NAME.ARR = "CUSTOMER"
    FLD.NAME.ARR = "NEW.LN.PROC"
    FLD.POS.ARR = ""
    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)
    VAL.POS = FLD.POS.ARR<1,1>

    Y.RCA.ID = Y.ENQ.DATA
    CALL F.READ(FN.REDO.CREATE.ARRANGEMENT,Y.RCA.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,Y.ARR.ERR)
    Y.CUSTOMER = R.REDO.CREATE.ARRANGEMENT<REDO.FC.CUSTOMER>
    IF Y.CUSTOMER THEN
        CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
        Y.VAL.PROC = R.CUSTOMER<EB.CUS.LOCAL.REF,VAL.POS>
        IF Y.VAL.PROC NE 'YES' THEN
            ENQ.ERROR = "EB-NOT.NEW.LN.PROC.CUST"
            RETURN
        END
    END
    Y.STATUS = R.REDO.CREATE.ARRANGEMENT<REDO.FC.LN.CREATION.STATUS>
    IF R.REDO.CREATE.ARRANGEMENT AND Y.STATUS EQ '' THEN
        ENQ.ERROR = "EB-LN.NOT.NEW.LN.PROC"
    END

RETURN
END
