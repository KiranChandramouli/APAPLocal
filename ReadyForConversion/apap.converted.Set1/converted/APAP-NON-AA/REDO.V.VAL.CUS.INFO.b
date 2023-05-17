SUBROUTINE REDO.V.VAL.CUS.INFO
*--------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This Routine will return customer details for REDO.L.NCF.ISSUE table
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
*   Date               who           Reference            Description
* 25-MAR-2010       Prabhu.N       ODR-2009-10-0321    Initial Creation
*--------------------------------------------------------------------------------
    $INSERT I_F.CUSTOMER
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.L.NCF.ISSUE

    GOSUB INIT
    GOSUB PROCESS
RETURN
*----
INIT:
*----
    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER =''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    LREF.APP='CUSTOMER'
    LREF.FIELDS='L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.ACTANAC':@VM:'L.CU.NOUNICO'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
RETURN
*-------
PROCESS:
*-------

    VAR.CUSTOMER.ID=COMI
    CALL F.READ(FN.CUSTOMER,VAR.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,ERR)
    VAR.CEDULA=R.CUSTOMER<EB.CUS.LOCAL.REF><1,LREF.POS<1,2>>
    R.NEW(NCF.IS.CEDULE.ID)=R.CUSTOMER<EB.CUS.LOCAL.REF><1,LREF.POS<1,1>>
    R.NEW(NCF.IS.RNC.NUMBER)=R.CUSTOMER<EB.CUS.LOCAL.REF><1,LREF.POS<1,2>>
    R.NEW(NCF.IS.IDENDITY.TYPE)=R.CUSTOMER<EB.CUS.LOCAL.REF><1,LREF.POS<1,3>>
    R.NEW(NCF.IS.UNIQUE.ID.NUM)=R.CUSTOMER<EB.CUS.LOCAL.REF><1,LREF.POS<1,4>>
    R.NEW(NCF.IS.PASSPORT)=R.CUSTOMER<EB.CUS.LEGAL.ID>
RETURN
END
