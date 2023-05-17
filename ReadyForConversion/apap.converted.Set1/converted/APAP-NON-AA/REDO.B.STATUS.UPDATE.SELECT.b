SUBROUTINE REDO.B.STATUS.UPDATE.SELECT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.B.STATUS.UPDATE.SELECT
*--------------------------------------------------------------------------------
* Description: Subroutine to perform the selection of the batch job
*
* Linked with   : None
* In Parameter  : None
* Out Parameter : SEL.CUSTOMER.LIST
*--------------------------------------------------------------------------------
* Modification History:
*02/01/2010 - ODR-2009-10-0535
*Development for Subroutine to perform the selection of the batch job
* Revision History:
*------------------
*   Date               who           Reference            Description
* 21-SEP-2011       Pradeeep S      PACS00090815          Credit Card status considered
*                                                         only for NON Prospect customer
* 29-Jan-2012      Gangadhar.S.V.  Perfomance Tuning  SELECT changed
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.STATUS.UPDATE.COMMON
    GOSUB INIT
    GOSUB SEL.REC
RETURN
*----
INIT:
*----
* 29-Jan-2012 - S
*    SEL.CUSTOMER.CMD="SELECT ":FN.CUSTOMER:" WITH CUSTOMER.TYPE NE PROSPECT"         ;* PACS00090815 - S/E
    SEL.CUSTOMER.CMD="SELECT ":FN.CUSTOMER
* 29-Jan-2012 - E
    SEL.CUSTOMER.LIST=''
    NO.OF.REC=''
RETURN
*-------
SEL.REC:
*-------
    CALL EB.READLIST(SEL.CUSTOMER.CMD,SEL.CUSTOMER.LIST,'',NO.OF.REC,AZ.ERR)
    CALL BATCH.BUILD.LIST('',SEL.CUSTOMER.LIST)
RETURN
END
