SUBROUTINE REDO.I.VAL.C25.BEN
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.I.VAL.C25.BEN
*--------------------------------------------------------------------------------------------------------
*Description  : This is a Input routine to check any one of benificiary field has value in the versions
* used for SAP webservices.
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 19 Aug 2012     Balagurunathan          PACS00211209           Initial Creation
*--------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER


    Y.APP=APPLICATION
    Y.FLD='BENEFIC.NAME'
    Y.POS=''
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD,Y.POS)

    FLD.POS= Y.POS<1,1>

    FLD.VAL=R.NEW(FT.LOCAL.REF)<1,FLD.POS,1>
    FLD.VAL1=R.NEW(FT.LOCAL.REF)<1,FLD.POS,2>

    IF FLD.VAL EQ '' AND FLD.VAL1 EQ '' THEN
        AF=FT.LOCAL.REF
        AV=FLD.VAL
        AS=1
        ETEXT='EB-REDO.BEN.INP.MISS'
        CALL STORE.END.ERROR

    END


RETURN

END
