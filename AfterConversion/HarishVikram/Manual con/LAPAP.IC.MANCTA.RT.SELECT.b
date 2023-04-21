*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.IC.MANCTA.RT.SELECT
    
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO                REFERENCE                 DESCRIPTION

* 21-APR-2023     Conversion tool    R22 Auto conversion       No changes

*-----------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.DATES
    $INSERT T24.BP I_F.CUSTOMER
    $INSERT T24.BP I_F.CUSTOMER.ACCOUNT
    $INSERT BP I_F.ST.LAPAP.EMP.COM.PAR
    $INSERT LAPAP.BP I_LAPAP.IC.MANCTA.RT.COMMON

    GOSUB DO.SELECT
    RETURN

DO.SELECT:

    SEL.ERR = ''; SEL.LIST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SELECT " : FN.CUS : " WITH CUSTOMER.STATUS EQ 1 AND L.CU.TIPO.CL EQ 'PERSONA JURIDICA'"

    CALL OCOMO("RUNNING WITH SELECT LIST : " : SEL.CMD)

    CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.LIST,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.REC)

    RETURN

END
