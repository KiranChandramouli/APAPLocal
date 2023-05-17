SUBROUTINE REDO.APAP.DS.AMT.TO.WORDS(Y.AMT)
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.DS.AMT.TO.WORDS
*------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display deposit amount
*               in words
*Linked With  :
*In Parameter : NA
*Out Parameter: Y.AMT
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date       Who                 Reference                Description
*   ------      ------              -------------            -------------
* 24-08-2010    JEEVA T             ODR-2009-10-0346 B.21    Initial Creation
* 10.11.2011    SUDHARSANAN S       CR.18                    MODIFY
* 18-02-2014    Vignesh Kumaar R    PACS00261598             AZ DEPOSIT DEALSLIP ALIGNMENT ISSUE
*--------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT

*--------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    LOC.APP = 'AZ.ACCOUNT'
    LOC.FIELD = 'ORIG.LCY.AMT':@VM:'L.AZ.DEP.NAME'
    LOC.REF = ''
    CALL MULTI.GET.LOC.REF(LOC.APP,LOC.FIELD,LOC.REF)

    POS.ORIG.LCY.AMT = LOC.REF<1,1>
    POS.L.AZ.DEP.NAME = LOC.REF<1,2>

    GOSUB PROCESS.PARA
RETURN
*--------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
    VAR.DEP.NAME = R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.DEP.NAME>
    IF VAR.DEP.NAME EQ 'DX' THEN
        IN.AMT = R.NEW(AZ.LOCAL.REF)<1,POS.ORIG.LCY.AMT>
*******This condition is used for USD deposits through SMB versions deal slip print*************
        IF NOT(IN.AMT) THEN
            IN.AMT=R.NEW(AZ.PRINCIPAL)
            CALL REDO.CONVERT.NUM.TO.WORDS(IN.AMT, OUT.AMT, LINE.LENGTH, NO.OF.LINES, ERR.MSG)
            VAR.OUT.AMT = EREPLACE(OUT.AMT,"pesos con","usd con")
            Y.AMT = UPCASE(VAR.OUT.AMT)
            RETURN
        END
*******This condition is used for USD deposits through SMB versions deal slip print*************
    END ELSE
        IN.AMT=R.NEW(AZ.PRINCIPAL)
    END

    CALL REDO.CONVERT.NUM.TO.WORDS(IN.AMT, OUT.AMT, LINE.LENGTH, NO.OF.LINES, ERR.MSG)

* Fix for PACS00261598 [AZ DEPOSIT DEALSLIP ALIGNMENT ISSUE]

    IF Y.AMT EQ 'AMT.WORD.1' THEN
        Y.AMT = UPCASE(OUT.AMT<1,1>)
    END

    IF Y.AMT EQ 'AMT.WORD.2' THEN
        Y.AMT = UPCASE(OUT.AMT<1,2>)
    END ELSE
        IF Y.AMT EQ '' THEN
            Y.AMT = UPCASE(OUT.AMT)
        END
    END

* End of Fix

RETURN
*-------------------------------------------------------------------------------------
END
