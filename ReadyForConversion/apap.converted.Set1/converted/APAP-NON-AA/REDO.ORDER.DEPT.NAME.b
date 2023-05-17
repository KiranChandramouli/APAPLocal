SUBROUTINE REDO.ORDER.DEPT.NAME

****************************************************
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : RAJA SAKTHIVEL K P
* Program Name : REDO.E.CNV.REL.DESC
*---------------------------------------------------------

* Description :
*----------------------------------------------------------
* Linked With :
* In Parameter : None
* Out Parameter : None
*----------------------------------------------------------
* Modification History:
* 02-Jun-2010 - HD1021443
* Modification made on referring to gosub WITH.RG.1.299.ONLY section for the ENQUIRY REDO.CUST.RELATION.VINC only
*----------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.H.MAIN.COMPANY


    FN.REDO.H.MAIN.COMPANY ='F.REDO.H.MAIN.COMPANY'
    F.REDO.H.MAIN.COMPANY = ''
    CALL OPF(FN.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY)


    Y.VAL =  O.DATA
    Y.ID =  FIELD(O.DATA,"*",1)
    Y.CODE = FIELD(O.DATA,"*",2)
    CALL F.READ(FN.REDO.H.MAIN.COMPANY,Y.ID,R.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY,Y.ERR)
    Y.CODE.LIST = R.REDO.H.MAIN.COMPANY<REDO.COM.CODE>
    Y.DES.LIST = R.REDO.H.MAIN.COMPANY<REDO.COM.DESCRIPTION>

    LOCATE Y.CODE IN Y.CODE.LIST<1,1> SETTING POS THEN
        O.DATA = Y.DES.LIST<1,POS>
    END




RETURN

END
