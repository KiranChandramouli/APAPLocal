SUBROUTINE REDO.CCRG.RISK.LIMIT.PARAM.ID
*-----------------------------------------------------------------------------
*!** FIELD definitions FOR TEMPLATE
* This routine validates the ID corresponding to the IDs of the virtual table
* REDO.CCRG.LIMIT registered in EB.LOOKUP application
*!
* @author:        anoriega@temenos.com
* @stereotype id: SubroutIne
* @package:       REDO.CCGR
* @uses:          ID.NEW, E
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------
    EB.LOOKUP.ID = ''
    R.EB.LOOKUP  = ''
    YERR         = ''
    EB.LOOKUP.ID = 'REDO.CCRG.LIMIT*' : ID.NEW
    CALL CACHE.READ('F.EB.LOOKUP',EB.LOOKUP.ID,R.EB.LOOKUP,YERR)
    IF NOT(R.EB.LOOKUP)THEN
        E = 'ST-REDO.CCRG.ID.LIMIT.IS.NOT.ALLOWED' : @FM : ID.NEW
    END
RETURN
END
