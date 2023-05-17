*--------------------------------------------------------------------------------------------------------
* <Rating>-20</Rating>
*--------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.CARD.REORDER.ID.CHK
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.REORDER.ID.CHK
*--------------------------------------------------------------------------------------------------------
*Description  : This is a ID routine to Automatically populate ID
*Linked With  : REDO.CARD.REORDER.DEST
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 1 DEC 2010    SWAMINATHAN       ODR-2010-03-0400        Initial Creation
* 14 NOV 2011   KAVITHA           PACS00152062            PACS00152062 FIX
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.COMPANY
$INSERT I_F.USER



  IF V$FUNCTION EQ 'I' THEN
    GOSUB INIT

    GOSUB PROCESS
  END
  RETURN
*-----------------------------------------------------------------------------------------------------------
INIT:
******

  FN.COMPANY = 'F.COMPANY'
  F.COMPANY = ''
  CALL OPF(FN.COMPANY,F.COMPANY)

  Y.VAL = COMI
  FINAL.COMP = R.COMPANY(EB.COM.FINANCIAL.COM)

  RETURN
*-----------------------------------------------------------------------------------------------------------
PROCESS:
*********

  CALL F.READ(FN.COMPANY,Y.VAL,R.COMP,F.COMPANY,Y.ERR.COMP)
  IF R.COMP EQ '' THEN
    IF Y.VAL EQ 'ID' THEN
      COMI = ID.COMPANY
    END
  END ELSE
    IF ID.COMPANY EQ FINAL.COMP THEN
      COMI = Y.VAL
    END ELSE
      IF Y.VAL EQ ID.COMPANY THEN
        COMI = ID.COMPANY
      END ELSE
        E = "EB-CANNOT.ACCESS.COMPANY"
      END
    END
  END
*PACS00152062 -S
  LOCATE COMI IN R.USER<EB.USE.COMPANY.CODE,1> SETTING POS.ID ELSE
    IF R.USER<EB.USE.COMPANY.CODE,1> NE 'ALL' THEN
      E = "EB-CANNOT.ACCESS.COMPANY"
    END
  END
*PACS00152062-E

  RETURN
*-----------------------------------------------------------------------------------------------------------
END
