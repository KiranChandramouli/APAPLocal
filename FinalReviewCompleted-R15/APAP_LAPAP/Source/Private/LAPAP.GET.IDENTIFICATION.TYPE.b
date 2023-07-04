* @ValidationCode : MjotODQ4MDYyNDYzOkNwMTI1MjoxNjg0MjIyODA5ODU2OklUU1M6LTE6LTE6LTE4OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -18
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP


SUBROUTINE LAPAP.GET.IDENTIFICATION.TYPE(R.CUSTOMER,OUT.ARR)

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO                 REFERENCE               DESCRIPTION

* 21-APR-2023   Conversion tool R22     Auto conversion         VM to @VM
* 21-APR-2023    Narmadha V             R22 Manual Conversion    No Changes

*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER ;*R22 Auto conversion - END

    GOSUB INIT
    GOSUB GET.VALUES
    GOSUB GET.CUST.IDEN.TYPE
    OUT.ARR = CUST.IDEN.TYPE

RETURN

INIT:
*****
    CUS.NATION = ''; YCUS.CIDENT = ''; YCUS.RNC = ''; YCUS.FOREIGN = ''; YCUS.LEGAL = ''
    CUST.IDEN.TYPE = ''; L.CU.PASS.NAT.POS = ''; Y.FIELD.POS = ''; L.CU.CIDENT.POS = ''; L.CU.RNC.POS = ''
    Y.APPLICATION = 'CUSTOMER'
    Y.FIELDS = 'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.PASS.NAT':@VM:'L.CU.NOUNICO':@VM:'L.CU.ACTANAC'
    CALL MULTI.GET.LOC.REF(Y.APPLICATION,Y.FIELDS,Y.FIELD.POS)
    L.CU.CIDENT.POS = Y.FIELD.POS<1,1>
    L.CU.RNC.POS = Y.FIELD.POS<1,2>
    L.CU.PASS.NAT.POS = Y.FIELD.POS<1,3>
    L.CU.NOUNICO.POS = Y.FIELD.POS<1,4>
    L.CU.ACTANAC.POS = Y.FIELD.POS<1,5>
RETURN

GET.VALUES:
***********
    CUS.NATION = R.CUSTOMER<EB.CUS.NATIONALITY>
    YCUS.CIDENT = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
    YCUS.RNC = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
    YCUS.FOREIGN = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.PASS.NAT.POS>
    YCUS.LEGAL = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    Y.L.CU.ACTANAC = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.ACTANAC.POS>
    Y.L.CU.NOUNICO = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.NOUNICO.POS>
RETURN

GET.CUST.IDEN.TYPE:
**************
    BEGIN CASE
        CASE YCUS.CIDENT NE ''
            CUST.IDEN.TYPE = 'CED'
        CASE YCUS.RNC NE ''
            CUST.IDEN.TYPE = 'RNC'
        CASE Y.L.CU.ACTANAC NE ''
            CUST.IDEN.TYPE = 'ACT'
        CASE Y.L.CU.NOUNICO NE ''
            CUST.IDEN.TYPE = 'NOU'
        CASE YCUS.LEGAL NE ''
            CUST.IDEN.TYPE = 'PAS'
        CASE YCUS.FOREIGN NE ''
            CUST.IDEN.TYPE = 'PAS'
    END CASE
RETURN

END
