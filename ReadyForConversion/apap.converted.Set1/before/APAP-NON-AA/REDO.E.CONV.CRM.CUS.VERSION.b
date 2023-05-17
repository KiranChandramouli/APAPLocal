*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CONV.CRM.CUS.VERSION
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : A Conversion routine choose Customer Version based on the local field L.CU.TIPO.CL
*
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Pradeep S
* PROGRAM NAME : REDO.E.CONV.CRM.CUS.VERSION
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
* 11.May.2011       Pradeep S          PACS00060849      INITIAL CREATION
* ----------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON

  Y.CUS.TYPE = O.DATA


  BEGIN CASE

  CASE Y.CUS.TYPE EQ 'PERSONA FISICA'
    O.DATA = 'CUSTOMER,REDO.CLIENTE.PF.MOD'
  CASE Y.CUS.TYPE EQ 'CLIENTE MENOR'
    O.DATA = 'CUSTOMER,REDO.CLIENTE.MENOR.MOD'
  CASE Y.CUS.TYPE EQ 'PERSONA JURIDICA'
    O.DATA = 'CUSTOMER,REDO.CLIENTE.PJ.MOD'
  END CASE

  RETURN
END
