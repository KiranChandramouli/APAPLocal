* @ValidationCode : Mjo2MzQ2OTI0NDc6Q3AxMjUyOjE2ODEzNjg3MTg0OTY6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2023 12:21:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.GET.ID.NUMBER
*
*DESCRIPTIONS:
*-------------
* This is an conversion routine used in the REDO.APAP.ENQ.MOD.CLIENT.RPT
* and REDO.APAP.ER.MOD.CLIENT.RPT
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                 Reference
* 06-SEP-10    Kishore.SP            INITIALVERSION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM , VM to @VM
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_ENQUIRY.COMMON
*-----------------------------------------------------------------------------
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:
*----------
*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*
    Y.CUS.VALUE = ''
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-------
*
    CUSTOMER.ID = O.DATA
*
    R.CUSTOMER = ''
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
    IF R.CUSTOMER NE '' THEN
        GOSUB FIND.MULTI.LOCAL.REF
        GOSUB GET.CUS.VAUES
        O.DATA = Y.CUS.VALUE
    END ELSE
        O.DATA = ''
    END
*
RETURN
*-----------------------------------------------------------------------------
FIND.MULTI.LOCAL.REF:
*--------------------
    APPL.ARRAY   = "CUSTOMER"
    FLD.ARRAY    = "L.CU.CIDENT":@VM:"L.CU.RNC":@VM:"L.CU.NOUNICO":@VM:"L.CU.ACTANAC"
    FLD.POS      = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.CU.CIDENT.POS  = FLD.POS<1,1>
    LOC.L.CU.RNC.POS     = FLD.POS<1,2>
    LOC.L.CU.NOUNICO.POS = FLD.POS<1,3>
    LOC.L.CU.ACTANAC.POS = FLD.POS<1,4>
RETURN
*-----------------------------------------------------------------------------
GET.CUS.VAUES:
*-------------
*
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.CIDENT.POS> NE '' THEN
        Y.CUS.VALUE<-1> =  R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.CIDENT.POS>
    END
*
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.RNC.POS> NE '' THEN
        Y.CUS.VALUE<-1> =  R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.RNC.POS>
    END
*
    IF R.CUSTOMER<EB.CUS.LEGAL.ID> NE '' THEN
        Y.CUS.VALUE<-1> =  R.CUSTOMER<EB.CUS.LEGAL.ID>
    END
*
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.NOUNICO.POS> NE '' THEN
        Y.CUS.VALUE<-1> =  R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.NOUNICO.POS>
    END
*
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.ACTANAC.POS> NE '' THEN
        Y.CUS.VALUE<-1> =  R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.ACTANAC.POS>
    END
*
    CHANGE @FM TO @VM IN Y.CUS.VALUE
RETURN
*-----------------------------------------------------------------------------
END
