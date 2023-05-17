SUBROUTINE REDO.V.INP.DISBURSE.OTI
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is an INPUT routine attached to below versions,
*

* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description*
* 21-07-2011         Bharath G        PACS00085750       Local Fields included in the version.
*------------------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.COMPANY

    GOSUB INIT
    GOSUB PROCESS
RETURN

******
INIT:
******
*Initialize all the variables

    FN.CUSTOMER = 'F.CUSTOMER'
    FN.CMPNY    = 'F.COMPANY'
    F.CUSTOMER = ''
    F.CMPNY    = ''
    CALL OPF(FN.CUSTOMER ,F.CUSTOMER)
    CALL OPF(FN.CMPNY ,F.CMPNY)

RETURN
***********
PROCESS:
***********
* PACS00085750 - S
    LREF.APP = 'FUNDS.TRANSFER'
    LREF.FIELDS = 'L.FT.CLIENT.COD':@VM:'L.FT.CLIENT.NME':@VM:'L.FT.CMPNY.ID':@VM:'L.FT.CMPNY.NAME'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    VAR.L.FT.CLIENT.COD.POS = LREF.POS<1,1>
    VAR.L.FT.CLIENT.NME.POS = LREF.POS<1,2>
    VAR.L.FT.CMPNY.ID.POS   = LREF.POS<1,3>
    VAR.L.FT.CMPNY.NAME.POS = LREF.POS<1,4>
*PACS00085750 - E

    Y.CUS.NO      =   R.NEW(FT.LOCAL.REF)<1,VAR.L.FT.CLIENT.COD.POS>
    Y.CMPNY.ID     =   R.NEW(FT.LOCAL.REF)<1,VAR.L.FT.CMPNY.ID.POS>

    CALL F.READ(FN.CUSTOMER,Y.CUS.NO,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
    CALL CACHE.READ(FN.CMPNY, Y.CMPNY.ID, R.CMPNY, Y.CMPNY.ERR)
    IF R.NEW(FT.LOCAL.REF)<1,VAR.L.FT.CLIENT.NME.POS> EQ '' THEN
        R.NEW(FT.LOCAL.REF)<1,VAR.L.FT.CLIENT.NME.POS> = R.CUSTOMER<EB.CUS.SHORT.NAME>
    END
    IF R.NEW(FT.LOCAL.REF)<1,VAR.L.FT.CMPNY.NAME.POS> EQ '' THEN
        R.NEW(FT.LOCAL.REF)<1,VAR.L.FT.CMPNY.NAME.POS> = R.CMPNY<EB.COM.COMPANY.NAME>
    END

RETURN
******************************************************************************************************
END
